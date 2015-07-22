---
layout:     post
title:      Cross Service Data Privacy
date:       2015-03-11
summary:    Experiment on Google usage of personal data across different web services
categories: blog
---


![Data privacy](https://innovateedu.files.wordpress.com/2014/09/cheap-data-collection.jpg)

## Background

Inside [XRay research team at Columbia University](http://xray.cs.columbia.edu/), we are motivated to be a public watcher of technology companies, expose their ways of using our personal data, and educate the general public. One interesting data privacy problem concerns user's activity across the web.

Say you recently bought a pair of Nike shoes on Amazon, two days later you log into Facebook. Automagically, the ads about workouts show up alongside your newsfeed.

From being shocked and furious to adapted and indifferent, we all know our "tech brothers" are watching us, but __how__?

Exposure of data track from the outside is challenging, and we conducted multiple experiments and discovered some interesting findings. This blog post walks through one of our major experiment design, together with some primitive findings.

To conduct a scientific experiment, we need to address the following challenges:

 1. What is one concrete question we try to answer?
 2. How do we transform that question into an experiment?
 3. How do we measure the success of the experiment?

All three questions provide critical functions throughout the process. The next section discusses how we address each of these questions.

### Ask the Right Question
  Our online personal information has been increasingly exploited, but users have little knowledge of how our data is used.
  Our research investigates on Google on how it uses user data, specifically, we attempt to address the following:

  > Does Google use user data within services to target outside services? If so, how?

### From Question to Experiment
  The compound question came with few concepts. **Data within services** is any set of data collected from Google services, such as Gmail accounts, Youtube search, etc. **Outside services** are websites that are not supervised by Google, such as Wall Street Journal, the Economist, etc.

  We can address two questions: first, can we find any evidence that what users do within Google service affects what users see on outside services? Second, can we find a flow that shows the effect?

  Our goal of the experiment is to find any `statistically significant hypothesis`, and the hypothesis is related to `targeting personal data`.  To further narrow down the direction of investigation, experiments have been designed to achieve two different goals:

  1. __Exploratory experiment__: find signals that a hypothesis is valid on certain inputs and outputs.
  2. __Validation experiment__: given a signal of valid hypothesis, refine the set of inputs and outputs, run further experiments.

  Each type of experiment has consistent variables:

  * __Profiles__: represents user information, for example, a Google account can a profile
  * __Inputs__: represents a particular profile-dependent activity within Google services
  * __Outputs__: represents a particular profile-dependent outcome from external services
  * __Uncontrolled Variables__: represents variables that may affect experimental results, but not within our experiment interests (IP, timestamp, etc.).

  Based on consistent variables, our experiments generated a set of __hypotheses__ to represent relationships that link inputs and outputs.

  Let's see how we can conduct *exploratory experiment* for *cross service targeting*, specifically, we want to test the following hypothesis:

  > Google utilizes `Youtube searches` to  `personalize ads` on external web sites.

  In our study, start by exploratory experiments, we model experiments for hypothesis above as follows:

  * __Profiles__: a set of registered Google accounts, with no previous account activities
  * __Inputs__: a set of search terms (i.e. finance, cancer, dog..).
  * __Outputs__: a set of ads appeared on external web sites (context sites) - such as Time of India, Wall Street Journal.
  * __Uncontrolled Variables__: timestamp of when an experiment was run, IP from which requests are made.
  * __Hypothesis__: a *causal relationship* for given input and output. An example case from which a hypothesis can be established:

  > Given a profile P1 has input ("finance" I1) on Youtube
  And profile sees an ad O1 (from WSJ on "Wolf of Wall Street")
  Then a hypothesis is I1 causes O1 shown

### Capture signals and noise

One interesting finding is that **activities on Google services are recorded**. Inside Google Account settings, there are [places that related to content targeting](www.google.com/settings/ads). Inside the ad setting, we see that Google tracks our interest based on our web activities.
![Google Ad settings](/images/cross_service_data_privacy.png)

As part of the experiment, we selected a few scenarios to test, and the main goal was to find any surprising signal that users' personal data is utilized in an unethical way. Specifically:

  1. Experiment A: Given profile searches videos about **finance** on **Youtube**, will financial ads be more likely to be listed on the sidebar when the user does Google search?
  2. Experiment B: Given a profile searches videos about **dogs** on Google search, will dog videos be more likely to be recommended on **Youtube**?

Here we need to quantify **more likely** mathematically. On a high level, we ran regression tests on different accounts and saw if there is any **significant difference** among different accounts.

Take experiment A as an example, we divide Google accounts into two groups: group X who did search for finance videos on Youtube and group Y who didn't search finance videos on Youtube. Later we provide same search terms set S for both groups, and we take snapshots on what sidebar ads the two groups see.

Now we keep track of the conditional probability: P(profile A sees financial ads given A is from X) and P(profile B sees financial ads given B is from Y). To ensure the correct results, we also run the experiments across multiple profiles.

The initial results weren't encouraging - we didn't find any strong signals suggesting that personal data from Youtube is used in other services such as Google search. What we realized is that cross targeting doesn't have one-to-one service targeting. Rather, it's likely that a web of services aggregate user activities to generate profile preference and then targeted contents are generated based on established profile preference.

These initial findings reveal more challenges for an outside to understand data privacy, yet it provides many directions for our future research. Lo and behold, research on data privacy and policy will continue to expand as it becomes increasingly problematic.
