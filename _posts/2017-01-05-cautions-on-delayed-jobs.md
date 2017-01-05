---
layout:     post
title:      Cautions on delayed job in Rails app
date:       2017-01-05
categories: blog
tags: ["Rails", "database"]
blog: true
---

Delayed Job (DJ) is a database (DB) based asynchronous priority queue system. In most cases, each job is persisted as one record persisted in a relational database, which means it implements fundamental conccepts, and also inherits performant limitations of relational database.

This blogpost assumes that DJ uses `MySQL` as the database.

## Caution 1: DB deadlock

### How does DJ locks?

Delayed jobs are [atomic](https://en.wikipedia.org/wiki/Atomicity_(database_systems)), so one jobe can only be performed by one worker at any given time. When a worker picks a job, it sets the job's **locked_at** to the current time and sets the job's **locked_by** to the worker's name.

Because worker's name applies to **locked_by** field, the name **should be** unqiue across the pool of worker.

### What is deadlock?

In MySQL, a deadlock is when two transactions each hold a lock on a row that the other requires to continue working. This leaves the two transactions waiting on the other transaction to release the lock, therefore both stuck forever because they're waiting for the other to finish.

### deadlock on DJ?

The sympton is that we have two workers try to acquire lock of the same job at the same time. When encountering that issue, `MySQL` kills one `UPDATE` process which crashes the server.

**replicate deadlock**

We can set up a concurrency test locally, start two workers and a self-replicating job. The job simply creates two more of itself, with semi-random `priority` and `run_at` values. This setup reliably replicates the deadlock within seconds.

To quote from the existing issue from [DelayedJob::ActiveRecord repository](https://github.com/collectiveidea/delayed_job_active_record/issues/63):

> The output of show engine innodb status says **the contention is between the UPDATE query now used to reserve a job, and the DELETE query used to clean up a finished job**. Surprising! 
Apparently the DELETE query first acquires a lock on the primary index (id) and then on the secondary index (priority, run_at). But the UPDATE query is using the (priority, run_at) index to scan the table, and is trying to grab primary key locks as it goes. Eventually the UPDATE and DELETE queries each grab one of two locks for a given row, try to acquire the other, and 💥. **MySQL resolves by killing the UPDATE, which crashes the worker**.

The dicussion also provides a fix:

> The fix I've worked out locally is to replace the index on (priority, run_at) with an index on (priority, run_at, locked_by). 
This completely stabilizes my concurrency test! My theory is that **it allows the UPDATE query's scan to skip over rows held by workers**, which takes it out of contention with the DELETE query.

## Caution 2: `UPDATE` on DJ

DJ relies `UPDATE` statement to assign jobs for workers, and a sample SQL looks like below

```
SQL (0.4ms)  UPDATE 'delayed_jobs' SET 'locked_at' = '2013-04-16 09:27:23', 'locked_by' = 'delayed_job.=2 host:ip-10-204-210-77 pid:2168' WHERE 'delayed_jobs'.'queue' IN ('queue_name') AND ((run_at <= '2013-04-16 09:27:23' AND (locked_at IS NULL OR locked_at < '2013-04-16 05:27:23') OR locked_by = 'delayed_job.=2 host:ip-10-204-210-77 pid:2168') AND failed_at IS NULL) ORDER BY priority ASC, run_at ASC LIMIT 1

```

Because the `WHERE` query inside the delayed jobs, **the more jobs we have in the queue, the slower it would be for a worker to pick up a job**. When we have a lot of delayed jobs in the table, the amount of time it takes to finish one job decreases because it takes longer for a worker to pick up a new job.

To quote from another blogpost on DJ performance tuning:

> the volume we processed was always low, this was never really a noticeable problem. But when we threw lots of new jobs into the queues, it became very noticeable. The worker would start up, then mysteriously die. After some digging in /var/log/kern.log we discovered the workers were being killed due to an out of memory manager. 
**Delayed job workers run a query each time they are looking for a new job to find out which job to pick up. It puts mutex on the record by setting locked_at and locked_by**.

One way to speed up `UPDATE` is to add index on the `queue` column. If we have a lot of jobs in database table, without index querying by `queue` will do a full table scane and take a lot of time to complete.

```ruby
def self.up
  create_table :delayed_jobs, :force => true do |table|
    # ... #
  end

  # ... #
  add_index :delayed_jobs, [:queue], :name => 'delayed_jobs_queue'
end
```

## Caution 3: DJ columns

### from `text` to `longtext`

To quote from [Delayed Job best practice](https://www.sitepoint.com/delayed-jobs-best-practices/):

> Some exceptions received by Delayed Job can be quite lengthy. If you are using MySQL, the handler and last_error fields may not be long enough. Change their datatype to longtext to avoid this issue. If you are using PostgreSQL, this will not be a problem.

```ruby
def self.up
  create_table :delayed_jobs, :force => true do |table|
    # ... #

    # replace the migration for column +handler+ with
    table.column :handler, :longtext, :null => false

    # replace the migration for column +last_error+ with
    table.column :last_error, :longtext

    # ... #
  end

  # ... #
  add_index :delayed_jobs, [:queue], :name => 'delayed_jobs_queue'
end
```

In code, we need to be cautious about how we are throwing errors and **supporess error messages** at the application level. Meanwhile, we can modify DJ columns to `longtext` for safeguarding.

### refer entity

Usually, a job is created in order to handle a background task that is related to a business entity. I am using two columns to store a reference to this business entity instance (polymorphic).

```ruby
def self.up
  create_table :delayed_jobs, force: true do |table|
    #...#

    table.integer :delayed_reference_id
    table.string :delayed_reference_type
  end

  add_index :delayed_jobs, [:delayed_reference_id],   :name => 'delayed_jobs_delayed_reference_id'
  add_index :delayed_jobs, [:delayed_reference_type], :name => 'delayed_jobs_delayed_reference_type'
end
```

## Caution 4: DJ configuration

By default, `Delayed::Worker.destroy_failed_job` is set to true, which means that workers delete failed jobs as soon as they reach the maximum number of attempts. This might be annoying when we want to find out the root problem and troubleshoot. To keep the failed job, we can do the following in the DJ initializer:

```ruby
Delayed::Worker.destroy_failed_jobs = false
```

By default, `Delayed::Worker.max_run_time` is set to `4.hours`. However, if you don’t expect to have such long running tasks, it is better to decrease that value. Doing so will kill the delayed worker when this limit is reached and allow the job to fail so another worker can pick it up. Also, you will be notified for tasks that you expected to run in short time but took longer.

```ruby
Delayed::Worker.max_run_time = 15.minutes
```

## Caution 5: DJ hooks

If we are using Rails, then we get [ActiveJobs](http://edgeguides.rubyonrails.org/active_job_basics.html) by default. Active Job provides hooks during the life cycle of a job. Callbacks allow you to trigger logic during the life cycle of a job:

```
* before_queue
* around_queue
* after_queue
* before_perform
* around_perform
* after_perform
```

DJ also provides a set of callback methods:
```
* enqueue
* success
* error
* failure
```

```ruby
class ProcessVideoJob < Struct.new(:video_id)
  def enqueue(job)
    job.delayed_reference_id   = video_id
    job.delayed_reference_type = 'VideoStreamer::Video'
    job.save!
  end
end
```

## Caution 6: DJ troubleshoot

If the woker queue isn't working, we can run the job manually and synchrously.

```ruby
# Method 1
job = Delayed::Job.where(queue: “normalization”).last
handler = job.handler
handler = YAML.load(handler)

klass = handler.job_data[“job_class”]
args = handler.job_data[“arguments”]
klass.constantize.new.perform(*args)


# Method 2
dw = Delayed::Worker.new
dj = Delayed::Job.last

dw.run(dj)
```

## Profit 7: DJ web

Like Sidekiq, DJ has an open source web interface, [delayed_job_web](https://github.com/ejschmitt/delayed_job_web).

## Reference

* [Delayed Job best practices](https://www.sitepoint.com/delayed-jobs-best-practices/)
* [delayed_job_web](https://github.com/ejschmitt/delayed_job_web)
* [DelayedJob::ActiveRecord deadlock issue](https://github.com/collectiveidea/delayed_job_active_record/issues/63)
* [Delayed Jobs callbacks and hooks in Rails](http://www.salsify.com/blog/engineering/delayed-jobs-callbacks-and-hooks-in-rails)
* [Prevent MySQL deadlocks in your Rails application](https://www.brightbox.com/blog/2014/11/13/preventing-mysql-deadlocks/)
