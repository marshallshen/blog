---
layout:     post
title:      Machine Learning Foundation (part 2 of 2)
date:       2016-12-11
categories: blog
tags: ["AI", "Machine Learning"]
blog: true
---

Following the previous blogpost, I will continue to explain some foundational ideas in ML:

  * **Algorithm Prototyping**. We look at the overall framework of ML algorithm prototyping, and briefly discuss certain mainstream ML algorithm.
  * **Algorithm Evauation**. We look at key process and metrics of evaluating the performance of an algorithm.
  * **Large machine learning (ML) systems**. We look at some challenges in building scalable ML systems and the general strategy to handle them.

## Prototyping Algorithm

### Define the problem

To over-simplify, the goal of a ML algorithm is..

> Given a set of data point, {% latex %}x_{1}, x_{2}, ... x_{n} \in X{% endlatex %}, and each data point has m features  {% latex %}x_{i} \in R_{m}{% endlatex %}, <br/>
  And an algorithm {% latex %}A{% endlatex %} takes the data point, <br/>
  And a cost function is defined {% latex %} f(A, X) {% endlatex %},<br/>
  Then we define a ML process that optimize the outcome of  {% latex %} f(A, X) {% endlatex %}


When prototyping a ML algorithm, we need to have the answers for the following:

* **Input**. What is my dataset? What features we are using for each data record?
* **Output**. What is the output based on the dataset? For example, it can be a categorical label, or a quantitative value.
* **Hypothesis**. What are the ML algorithm(s) we are going to try, with what parameters?
* **Cost function**. What is the cost function we are going to use, to optimize the algorithm(s) against?

Note that in this blogpost, an **algorithm** refers to the abstract mathematical framework to form a **hypothesis**, whereas a **hypothesis** is the **concrete** model with parameters calculated using the **algorithm** and the **given dataset**.

### Mainstream algorithms

Depending on the type of the problem, either a `supervised` or `unsupervised` learning problem, the [Coursera class](https://www.coursera.org/learn/machine-learning) introduces some mainstream algorithms:

* Supervised Learning
  - Regression (linear, multi-polynomial, logistic)
  - Neural Networks
  - Support Vector Machine
* Unsupervised Learning
  - K means cluster
  - Principla Component Analysis
  - Collaborative Filtering (recommender system)
  - Low Rank Matrix (recommender system)

Although each school of algorithm follows different process, I find that **general framekwork* of these algorithms rather similar (input, output, hypothesis, cost function). The technical detail of each algorithm is outside the scope of this blogpost.

## Evaluating Hypothesis

When different hypothesis are formed given a dataset, we want to have a process to help determine which hypothesis makes better prediction than others. In general, the fruition of a hypothesis comes from two steps: **training step** and **testing step**. Each step requires dataset.

We split a whole dataset into three parts: **training set**, **validation set**, and **test set**. To quote from the [Coursera class](https://www.coursera.org/learn/machine-learning), the rationale of splitting the dataset three ways is:

> Just because a learning algorithm fits a training set well, that does not mean it is a good hypothesis. The error of your hypothesis as measured on the data set with which you trained the parameters will be lower than any other data set.

 As a rule of thumb, 60% of the whole dataset should be training set, 20% should be validation set, and the rest 20% should be test set, and the three datasets can be applied as below:

* **Training set**. Reommeded to be 60% of the entire dataset. It is applied in **training algorithm** to learn paratmers within the hypothesis.
* **Validate set**. Reommeded to be 20% of the entire dataset. It is applied in **training algorithm** to tune paratmers within the hypothesis.
* **Testing set**. Reommeded to be 20% of the entire dataset. It is applied in **testing algorithm** to verify the performance of the hypothesis.


### Underfitting vs. Overfitting

When bad prediction of a hypothesis happens, we need to understand what contributes to the bad prediction. There are two main errors that can cause a bad prediction:

* **Underfitting(High Bias)**. The hypothesis performs bad against both training set and validation set.
* **Overfitting(High Variance)**. The hypotheis performs well against training set, but bad against validation set.

![Underfitting vs. Overfitting](/images/learning_curve.png)

To over simplify, the steps of troubleshooting a underperforming hypothesis are:

1. Understad what is the cause of underperformance (bias vs. variance).
2. Apply techniques based on the type of underperformance.

The details of how to diagnose and improve performance of hypothesis is beyond the scope of this blogpost.

## Large ML systems

Two major challenges are present when building a large ML systems.

* **Dataset size**. The algorithm is consuming a large amount of data (terrabytes of data), which requires long computation time.
* **Continuous stream of data**. With a continuous stream of users to a website, we can run an endless loop that gets (x,y), where we collect some user actions for the features in x to predict some behavior y.

Several techniques have been introduced in class, including [Stochastic Gradient Descent](https://en.wikipedia.org/wiki/Stochastic_gradient_descent), [Online Learning](https://en.wikipedia.org/wiki/Online_machine_learning), and [MapReduce](https://en.wikipedia.org/wiki/MapReduce). The goal of these technqieus is to speed up the computing process, and the big ideas can be summarized below:

* **Stochastic Gradient Descent**. It speeds up ML system by speeding up algorithm. It allow algorithm to run without having to scan through the entire dataset.
* **Online Learning**. It speeds up ML system by speeding up algorithm. The algorithm can update paramter of a hypothesis by each data point as it gets collected.
* **MapReduce**. It speeds up ML system by adding more machine. We split dataset into subsets corresponding to the number of machines you have. On each of those machines we calculate results, and then later merge all results back to master machine to get the final results.


