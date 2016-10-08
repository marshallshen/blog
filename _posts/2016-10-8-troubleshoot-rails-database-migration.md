---
layout:     post
title:      Troubleshoot Rails database migration
date:       2016-10-08
categories: blog
tags: ["Ruby", "Rails", "database"]
blog: true
---

Every now and then I run into database migration error using Rails, so I write this blogpost to dissect this problem.

## The Problem

When I work on my development branch, and I have some migrations to run, it works fine if I run `rake db:migrate`. However, when I rebase a remote branch with outstanding migrations, if I run `rake db:migrate`, I may get the following error:

    SQLException: duplicate column name: some_column_name

## The Cause

We work in a mulit-developer environment, and new database migrations are being developed separately. We are also committing to `db/schema.rb` into our git, which makes it possible to have **conflicting timestamp on the schema entry**.

Specifically, the problem arises if my local migrations are not in sync with the database schema. This happens  when a remote branch is rebased into a local branch and a rebase conflict needs to be resolved by manually modifying `schema.rb`. When `rake db:migrate` is run, Rails rely on `schema_migrations` tables to recognize which migrations have been run.

## The Fix

Follow these 3 steps to troubleshoot the problem

### Step 1. compare `schema_migrations` on remote and local database

Open up `rails db_console` on local and remote database, and run

    SELECT * FROM schema_migrations;

Compare the entries side by side to detect the difference.

![schema_diff](/images/schema_diff.png)

The source of truth for schema timestamp should be the master branch of the application cdode:

![master_schema](/images/master_schema.png)

### Step 2. Identify missing `schema_migrations` entry on remote

Add the missing entry to the remote table, but ** don't remove any entry on remote **. Follow a **only add, never remove** strategy. In the example above, add *20161001032849* entry to the remote. 

     INSERT INTO schema_migrations VALUES ('20161001032849');

### Step 3. Verify the entry on remote `schema_migrations`

![correct_schema](/images/correct_schema.png)

Now `rake db:migrate` should work fine on the remote server!

## The takeaways

Two things we can do better to prevent the schema error:

  1. When encontering merging conflicts on `schema.rb` file, pay attention to the timestamp and identify which timestamp number to use.
  2. When running `rake db:migrate` fails locally, don't run **rake db:reset**, instead looking into `schema.rb` file and correct the timestamp version within `schema.rb`.

![comparing_schema_version](/images/compare_schema_version.png)
