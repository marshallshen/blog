---
layout:     post
title:      Data Privacy on Gmail Ads
date:       2015-02-21
summary:    How did Google use our email contents to target ads
categories: blog
---

### Background
Today’s Web services - such as Google, Amazon, and Facebook–leverage user data for varied purposes, including personalizing recommendations, targeting advertisements, and adjusting prices. At present, users have little insight into how their data is being used. Hence, they cannot make informed choices about the services they choose.

To increase transparency, my research team at Columbia University started [project XRay](http://xray.cs.columbia.edu/). We aim to build scalable data tracking system to function an outside watcher on data tracking by other tech companies. We want to predict which data in an arbitray web profile (such as emails, searches, or viewed products) is being used to target which output (such as ads, recommended products, or prices).

![What are they doing with your data?](/images/what_are_they_doing_with_your_data.png)

### Data Tracking on Gmail Ads
Because data tracking is everywhere, we have lots of options to explore. Hence, it's crucial to narrow down our scope and focus on specific service, or even a specific application. In our research, we are interested in **How Google services track our data**, one service we decided to explore on was Gmail Ads. As of June 2014, there were 425 million Gmail accounts, and the number was growing about 1 million per week. From Google's perspective, it's financially motivating to target user with right ads. From users' perspective, it's alerting whether private information is being exposed and utilized in unethical way.

#### Understand types of user data
When a user interacts on the web, there are three major behaviors that worth tracking. They are **behavorial**, **contextual**, and **personal** data.

**Behavorial data** is records of what a user does on the Internet: watching a baby laughing video on Youtube; liking a baby laughing video on Youtube; searching for more baby laughing video on Google; sending emails to your friends with a baby laughing video. These behaviors are all recorded by the services (and yes I like baby laughing videos).

**Contextual data** is topic and content that related to **time** and **location**. For example, in May 2015, British Election is a trending event in the world and is considered as contextual data. If you reside in London, which most likely is reflected by your IP address, that location is also recorded as contextual data.

**Private data** is self-explanatory: user's gender, age, race, nationality, maritial status, sexual orientation, religion beliefs.. This type of data needs most protection yet are definitely used for user targeting.

#### Formulate Question
Now that we understand different user data types, our research team wants to address the following questions:

> How did Gmail utilize our **email contents** to **target ads**?

![Gmail Ads demo](/images/gmail_ads.png)

### Experiments and Findings
On a high level, the experiments we ran are large-scale; we crafted email contents based on certain themes, controlled setups of emal accounts (age, gender), and collected experiment data on different days. We also controlled IP addresses to reduce noises because we want to capture signals of email contents being used, by holding everything else as constant as possible.

In summary, we have:

- **30** experiment iterations
- **30** test accounts
- **300** email snapshots per iteration
- **1 million** ad snapshots per iteration
- **700** targeting scores per iteration

After several rounds of experiments, some interesting pattern emerged showing that **Google does use user email contents to target Gmail Ads**. The following table summarizes some interesting patterns we saw:

| Theme              | Content keywords | Ads users more likely to see      |
|--------------------|------------------|-----------------------------------|
| Marriage           | Divorce          | Law Consulting                    |
| Sexual Orientation | Gay              | Underwear commercial              |
| Social Service     | Veteran          | Truck driving certification class |
| Race               | African American | Scam checks                       |
| Race               | Latino           | Nestle Coffee Recipe              |
| Religion           | Mormon           | Genealogy                         |
| Religion           | Catholic         | Jewelry                           |
| Religion           | Church           | Retirement financial service      |


### What's next?
The initial findings are encouraging and reveal many interesting patterns, the team are excited to follow these intial signals, simplify experiment process, and share our results with the public.

We try to improve on automation of experiments. Currently setting up experiment is still a fairly manual process. Many settings, such as creating user accounts, fixing IP addresses and web cookies, before we can run a large-scale experiments. Using the knowledge we gain, we are in process of building an experiment workflow that abstract some repeatable experiment set ups.

We also try to expose value data to the general public. One application of our research to allow journalists search privacy patterns themselves. We intend to make our experiment data available to the public in a meaningful way, and a big intiate we started is to integrate our research data with search engine framework such as Elasticsearch, and we have a primitive version [available](www.xray-search.com) to the general public.

In sum, enhancing data privacy is a constant battle and I'm very happy to be part of this research! I also [gave a talk](https://vimeo.com/125051909) on the same topic if you want to learn more about it!

