---
layout:     post
title:      The math of logistic regression
date:       2017-08-26
categories: blog
tags: ["AI", "Machine Learning"]
blog: true
---

This post demonstrates the mathematical model behind **logistic regression**, which serves as the building block of the [deep learning](https://en.wikipedia.org/wiki/Deep_learning). I write this post to help others understand deep learning, I also write it for myself to learn deep learning more deeply.

I break down each subject into two posts, the **math post** explaining how an idea works theoretically, and the **code post** demonstrating how to implement the idea into code. To demonstrate `logistic regression`, I will apply the theory to [image recognition](https://en.wikipedia.org/wiki/Pattern_recognition), a well-studied machine learning subject, later in the **code post**. This post lays the foundation for understanding the model.


## Model after biological neuron

Modern deep learning techniques model after biological cognition, the basic unit of which is neuron. It is the building block of deep learning starts with neuron-inspired math modeling using logistic regression. The math behind a simple logistic regression classifier looks like below:

![](/images/neuron.png)

Image this function represents a neuron in your brain, the **input** is the stimulus your brain received (sound, touch, etc.), represented by the data captured in {% latex %} x {% endlatex %}; and the **output** is a binary decision of whether that neuron gets triggered or not, represented by the binary value of {% latex %} \hat{y} {% endlatex %}.

In order to have the neuron work properly, we need to have decent value for weights and bias terms, denoted as {% latex %} w {% endlatex %} and {% latex %} b {% endlatex %} respectively. However, we don't have good values for {% latex %} w {% endlatex %} nor {% latex %} b {% endlatex %} automatically, we need to **train our model and acquire good weights and bias terms.** Image our function as a newborn baby, and it takes training to teach a baby to walk, speak etc. We need to train our neuron model and figure out good values for {% latex %} w {% endlatex %} and {% latex %} b {% endlatex %}.

So the question is **how to train for logistic regression**? Given we have a set of training dataset, we can measure the error of our current model by comparing predicted value and actual value, then take the result to do better. We can break down the question of **how to train for logistic regression** into a set of smaller problems:

- question 1: how to define the error of predictions from our model?
- question 2: how to take the error to refine our model?

The technique to address question 1 is called **forward propagation**, and the technique to address question 2 is called **backward progation**. 


## Forward Propagation

Forward progation enables two things. First, it provides a predicted value {% latex %} \hat{y} {% endlatex %} based on the input {% latex %} x {% endlatex %}. To break down the calculation mathematically:

- {% latex %} z^{(i)} = w^{T}x^{(i)} + b {% endlatex %}
- {% latex %} a^{(i)} = \frac{1}{1+ e^{-z^{(i)}}} {% endlatex %}

If the value of {% latex %} a^{(i)} {% endlatex %} is greater than or equal to 0.5, then {% latex %} y^{(i)} {% endlatex %} is predicted as 1, otherwise {% latex %} y^{(i)} {% endlatex %} is 0.

Second, it allows the model to calculate an **error** based on a **loss function**, this error quantifies how well our current model is performing using {% latex %} w {% endlatex %} and {% latex %} b {% endlatex %}. The loss function for the logistic regression is below:

- {% latex %} \iota(a, y) = ylog(a) + (1 - y)log(1-a) {% endlatex %}

How does this loss function makes sense? The way I think about is that if the prediction is close to actual value, the value should be low. If the prediction is far from actual value, the value should be high. Gi

### cost function based on loss function

Next we define a **cost function** for the entire dataset based on the **loss function** because we have many rows of training data, say {% latex %} m {% endlatex %} records. The value of the error based on the cost function is avaraged out across all errors:

- {% latex %} \iota(a^{(i)}, y^{(i)}) = - \frac{1}{m} \sum_{i=1}^{m} y^{(i)}log(a^{(i)}) + (1 - y^{(i)})log(1-a^{(i)}) {% endlatex %}
- {% latex %} J = \frac{1}{m}\sum_{i=1}^{m}\iota(a^{(1)}, y^{(i)}) {% endlatex %}

Given we have a way to measure the error of our prediction model, we can set the goal to **minimize prediction error by adjusting our model parameters**, and this is where backward propagation comes in.

## Backward Propagation

To tackle the problem of **how to refine our model to reduce training error**, we can more formally define our problem as following:

1. Given a dataset {% latex %} X {% endlatex %}
2. The model computes {% latex %} A = \sigma(w^T X + b) = (a^{(0)}, a^{(1)}, ..., a^{(m-1)}, a^{(m)}) {% endlatex %}
3. The model calculates the cost function: {% latex %} J = -\frac{1}{m}\sum_{i=1}^{m}y^{(i)}\log(a^{(i)})+(1-y^{(i)})\log(1-a^{(i)}) {% endlatex %}
4. Apply cost function {% latex %}J{% endlatex %} to adjust {% latex %}w{% endlatex %} and {% latex %}b{% endlatex %}

To implement step 4, we need to apply **gradient descent**.

### Gradient Descent

Quote from [Wikipedia on gradient descent](https://en.wikipedia.org/wiki/Gradient_descent):

> Gradient descent is a first-order iterative optimization alogirthm for finding the **minimum of a function**.

Great! We want to find the minimum of our cost function by adjusting {% latex %}w{% endlatex %} and {% latex %}b{% endlatex %}. Following the gradient descent algorithm, we take the following steps:

1. taking partial derivatives off our parameters, which tells us the delta values of adjusting that value
2. update our parameters based on the delta value from the partial derivatives

![](/images/gradient_descent.png)

The goal is to learn {% latex %}w{% endlatex %} and {% latex %}b{% endlatex %} by minimizing the cost function {% latex %}J{% endlatex %}. For a parameter {% latex %}\theta{% endlatex %}, the update rule is {% latex %} \theta = \theta - \alpha \text{ } d\theta{% endlatex %}, where {% latex %}\alpha{% endlatex %} is the learning rate.

Translate the steps above mathematically, we get:

**update w**

- {% latex %} \frac{\partial J}{\partial w} = \frac{1}{m}X(A-Y)^T {% endlatex %}
- {% latex %} w := w - \alpha\frac{\partial J}{\partial w} {% endlatex %}

**update b**

- {% latex %} \frac{\partial J}{\partial b} = \frac{1}{m} \sum_{i=1}^{m} (a^{(i)}-y^{(i)}) {% endlatex %}
- {% latex %} b := b - \alpha\frac{\partial J}{\partial b} {% endlatex %}

## Put it all togher

We can now have a big picture of how we want to use logistic regression classifier to predict future dataset based on training dataset. A high-level architectural steps can be summarized as:

1. Gather training dataset {% latex %} (X_{train}, Y_{train}) {% endlatex %} and test dataset {% latex %} (X_{test}, Y_{test}) {% endlatex %}.
2. Initialize model parameters {% latex %} w {% endlatex %} and {% latex %} b {% endlatex %}.
3. Define learning rate {% latex %} \alpha {% endlatex %}, and number of training iterations.
4. For each training iteration, run through:
    - apply forward propagation with {% latex %} (X_{train}, Y_{train}) {% endlatex %}, {% latex %} w {% endlatex %} and {% latex %} b {% endlatex %}
    - calculate cost funtion {% latex %} J {% endlatex %}
    - apply backward propagation to adjust {% latex %} w {% endlatex %} and {% latex %} b {% endlatex %}
5. Verify the accuracy of the model using {% latex %} (X_{test}, Y_{test}) {% endlatex %}

In the next blog post [the code of logistic regression](), we will dive into the implementation of logistic regression based on the model above.



