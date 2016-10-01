---
layout:     post
title:      Build Rules Engine using Functional Programming
date:       2016-10-01
categories: blog
tags: ["Ruby", "functional programming", "sofware design"]
blog: true
---

## What is rules engine

Rules engine is a common type of software for business. In Wikipedia, the [definition](https://en.wikipedia.org/wiki/Business_rules_engine) is:

  > A business rules engine is a software system that executes one or more business rules in a runtime production environment... 
  >  
  > Rule engines typically support rules, facts, priority (score), mutual exclusion, preconditions, and other functions.

Using an over-simplified equation the represent rules engine:

     Data + Rules = Solution

Before we discuss how to build rules engine we define how we identify a good rules engine. A good rules engine should have three business traits: **feasibility**, **extensibility**, and **measurability**.

**Feasibility.** Given a set of rules and a data set, a rules engine should be able to produce a feasible solution. Same inputs can always reproduce the same output.

**Extensibility.** A rules engine can adapt to business change easily.

**Measurability.** A rule engine should know how to assess a solution based on rules and dataset.

Given the three traits above, we will discuss different ways to build a rules engine by studying a mock case.


## Build rules engine

Think of a case of content programming on Youtube. The task is to build an algorithm that compiles a playlist for content videos with sponsored ads. There are two datasets to build this list:

  - A collection of content videos
  - A collection of ad videos

Note that each video has its duration.

We also have a set of rules that regulates how a playlist should be programmed. Simplifying the case, the playlist programming only has “IF condition THEN action” rule. A possible list of rules can be:

  - the total duration of the playlists is 30 minutes.
  - No same video can be played back to back.
  - The ads can not be played more than 30% of total time.
  - No ads can be played back to back.


The rules above include two types: one type of rules that help determine “what to play,” and the other type of rules that determines “how to play given what to play.” We can think of “what to play” rules as *selection rules*, and “how to play given what to play” as *sorting rules*.

![youtube_mock_case](/images/youtube_playlist.png)

### Object-Oriented approach: object chain

The problem can be broken into a set of small problems, and we can construct objects that hold the responsibility of solving a specific small problem. The object knows its state, and its data and functions.

We can divide the playlist programming problem into three smaller steps: select,  sort and validate.  We construct *Selector*, *Sorter*, and *Validator*. Each object has a single responsibility of solving a small problem.

| Object      |                            Reponsibility                            |
|-----------  |-------------------------------------------------------------------: |
| Selector    |            Find all the videos based on selection rules             |
| Sorter      | Generate a playlist based on the selected videos and sorting rules  |
| Validator   |             Measure how good the generated playlist is              |

Below is a visual overview of how the objects interact in the process:

![oo_rules_engine.png](/images/oo_rules_engine.png)

Our code might look like the following:

{% gist 9f093c3b3b0a24dc3df69adcbab26c6a selector.rb %}
{% gist 9f093c3b3b0a24dc3df69adcbab26c6a sorter.rb %}
{% gist 9f093c3b3b0a24dc3df69adcbab26c6a validator.rb %}

Two drawbacks exist in this approach. Regarding extensibility, the structure of Selector, Sorter and Validator may not be flexible enough to accommodate a new business case because both classes have established attributes and states. Also, each object depends on attributes from the previous object (Sorter relies on Selector, validator relies on Sorter); such dependency might cause unexpected errors if the dependent data is not present.

Regarding measurability, we can write integration tests to verify the correctness of output given certain inputs, but it’s more complicated to write unit testing. To do so we need to mock out an object's dependent objects as well as their state and data, then verify that the state and data of tested object class are correct.

### Functional approach: function pipeline

Using Functional Programming paradigm, the playlist programming can be divided into a set of small functions. All steps take a data hash as its inputs and outputs a data hash with the same structure. Each step appends its key-pair inside the hash, and it passes on the hash to next step.

Below is a visual overview of how the functions interact in the process:

![functional_rules_engine.png](/images/functional_rules_engine.png)

Our code might look like the following:

{% gist 9f093c3b3b0a24dc3df69adcbab26c6a rules_engine.rb %}
{% gist 9f093c3b3b0a24dc3df69adcbab26c6a youtube.rb %}

Several benefits stand out using this approach. The rules engine becomes more adaptable to business change. Because no function depends on other function, we can easily swap in and out new functions as long as that function understands the input and provides expected output. 

Additionally, writing tests for individual function becomes easier because we can verify given certain inputs, the function computes an expected output. Lastly, regarding development, function pipeline gave developers the flexibility to adjust algorithms, many times we overcome a technical difficulty by adding a new function to the pipeline.

## Conclusion

Considering the standards of a good rules engine, I find the functional programming a better approach in building flexible rules engine.



