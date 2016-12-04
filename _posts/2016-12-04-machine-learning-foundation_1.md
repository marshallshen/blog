---
layout:     post
title:      Machine Learning Foundation (part 1 of 2)
date:       2016-12-04
categories: blog
tags: ["AI", "Machine Learning"]
blog: true
---

I recently finished [Machine Learning class on Coursera](https://www.coursera.org/learn/machine-learning). It's a great entry-level Machine Learning (ML) class. In this blog post and another following post I attempt to explain, in simple terms, some foundamental concepts in machine learning. Rather than drilling into mathematical details of ML techniques, this post starts with high-level way of thinking (e.g. how to decided which algorithm to try?).

## What is Machine Learning?

Simply put, machine learning is a technique to **teach computers to learn certain tasks**, it is about developing algorithms that learn how to perform certain tasks given a large amounts of data. Some interesting tasks include:

* Detect financial fraud by analyzing credit card transation
* Self-driven automobile
* Facial recoginition of images

The **learning** can be divided into two categories: **supervised** and **unsupervised** learning. Supervised learning handles **labeled** data and attempt to **classify** or **predict** based on labled data (training set). Unsupervised learnings handles **unlabled** data and attempt to detect trends and patterns (clustering).


## Machine Learning Approach

Most machine learning problems share **similar iterative, pipeline approach** because the large picture of most ML remains similar, which can be roughly summarized as follows:

> Given we **reliably collect** a large set of data <br/>
> And we **define a task** ML algorithm is supposed to learn <br/>
> First We perform **proprocessing** of data <br/>
> Then we **prototype** algorithms to accomplish defined task <br/>
> And we **evaluate the fitness** of algorithms <br/>
> And we **improve algorithms** based on the evaluation.

### Collect Data

When we collect data for a ML problem, we should ask the following questions:

1. What's the context of the data? 
2. What are the bias within the data, are the bias related to the defined task?
3. How clean is the data (missing fields, etc)?
4. Can we get more data? 

The technique of `Artificual Synthesis` is applied often to generate more data. The idea is that we can "simulate" more data based on real data. One example used is [Optical Character Reader](https://en.wikipedia.org/wiki/Optical_character_recognition), researchers combine background of one image with the letter of another image to form a new image and include the synthesized image as a data point.

![](/images/ocr.png)

### Define a task

Beware what tasks can we perform based on the **nature of data**. For example, it might be more difficult to perform prediction related tasks using **unlabeled data**. To borrow from a great [Stackoverflow answer on labled data vs. unlabeled data](http://stackoverflow.com/questions/19170603/what-is-the-difference-between-labeled-and-unlabeled-data):

> Typically, **unlabeled data** consists of samples of natural or human-created artifacts that you can obtain relatively easily from the world. Some examples of unlabeled data might include photos, audio recordings, videos, news articles, tweets, x-rays (if you were working on a medical application), etc. There is no "explanation" for each piece of unlabeled data -- it just contains the data, and nothing else. <br/><br/>
> **Labeled data** typically takes a set of unlabeled data and augments each piece of that unlabeled data with some sort of meaningful "tag," "label," or "class" that is somehow informative or desirable to know. For example, labels for the above types of unlabeled data might be whether this photo contains a horse or a cow, which words were uttered in this audio recording, what type of action is being performed in this video, what the topic of this news article is, what the overall sentiment of this tweet is, whether the dot in this x-ray is a tumor, etc.

### Preprocess data

The goals of preprocessing data are twofold: first to get a feel of the dataset before we dive into algorithm development, and second to normalize data to similar scale. To get a feel of the data, **visualizing data*** helps. The idea of [Dimensionality Reduction](https://en.wikipedia.org/wiki/Dimensionality_reduction) is applied when handling dataset with high dimensions, which maps data {% latex %} R^{n} \rightarrow R^{2}, R^{3}{% endlatex %}.

One technique of dimensionality reduction is [Principle Component Analaysis (PCA)](https://en.wikipedia.org/wiki/Principal_component_analysis), which is a linear transformation that can be defined as followings:

> Given a dataset {% latex %}X \in R_{k}{% endlatex %} of size {% latex %}m{% endlatex %}, <br/>
> We want to compute a **transformation matrix** {% latex %}U{% endlatex %} to reduce to {% latex %}Z \in R_{k}{% endlatex %} where {% latex %}k < n{% endlatex %}, <br/>
> So that {% latex %} Z = U^{T} X{% endlatex %}

Another great visualized example of PCA can be found [here](http://setosa.io/ev/principal-component-analysis/).

To normize data to similar scale, we perform a data transformation defined as follows:

> Training set: {% latex %} x^{(1)}, x^{(2)}... x^{(m)} {% endlatex %} <br/><br/>
> {% latex %} \mu_{j} = \frac{1}{m} \sum x_{j}^{(i)} {% endlatex %} <br/><br/>
> Replace each {% latex %} x_{j}^{(i)} {% endlatex %} with {% latex %} \mu_{j} - x_{j}^{(i)} {% endlatex %} <br/>

The benefit of **feature scaling** is to speed up the computation of algorithm later on, you can read more about [why feature scaling](http://stackoverflow.com/questions/26225344/why-feature-scaling) to learn the rationale behind it.

## To Be Continued

In the following blogpost, we will discuss more foundation ideas behind **prototyping algorithms**, **evaluating algorithms** and build **large machine learning (ML) systems**.

