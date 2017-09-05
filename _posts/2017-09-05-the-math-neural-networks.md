---
layout:     post
title:      The math of neural networks
date:       2017-09-05
categories: blog
tags: ["AI", "Machine Learning"]
blog: true
---

Building neural networks is at the heart of any deep learning technique. Neural networks is a series of forward and backward propagations to train paramters in the model, and it is built on the unit of logistic regression classifiers. This post will expand based on [the math of logistic regression](http://himarsh.org/the-math-of-logistic-regression/) to build more advanced neural networks, in mathematical terms.

A neural network is composed of **layers**, and there are three types of layers in a neural network: one **input layer**, one **output layer**, and one or many **hidden layers**. Each layer is built based on the same structure of logistic regression classifier, with **a linear transformation** and **an activation function**. Given a fixed set of input layer and output layer, we can build more complex neural network by adding more **hidden layers**. 

Before diving into the details of the mathematical model, we need to have a big picture of the computation. To quote from [deeplearning.ai] class:

> the general methodology to build a Neural Network is to:
>
>  1. Define the neural network structure (number of input units, number of hidden units, etc.)
>
>  2. Initialize the model's parameters
>  
>  3. Loop
>    - Implement forward propagation
>    - Compute loss
>    - Implement backward propagation to get the gradients
>    - Update parameters (gradients)

To make it easier to understand, we take an iterative approach to break down the math of neural networks, first we analyze a **2-layer neural network**, then we analyze **L-layer neural network**.

## Two-layer neural network

Let's think of the following hypothetical scenario: we have two nodes {% latex %}x_{1}{% endlatex %} and {% latex %}x_{2}{% endlatex %} for input layer, three nodes defined in the hidden layer, and we have one node {% latex %}y{% endlatex %} for the output layer. Converting the graph below into mathematical terms, we have:

![two_layer_neural_network.png](/images/2_layer_neural_network.png)

The following is our input parameters where we specify the 2-layer neural network:

1. Input layer {% latex %}X \in (2, 1){% endlatex %}, with its weight {% latex %}W_{1}{% endlatex %} and bias {% latex %}b_{1}{% endlatex %}
2. Oput layer {% latex %}Y \in (1, 1){% endlatex %}, with its weight {% latex %}W_{2}{% endlatex %} and bias {% latex %}b_{2}{% endlatex %}
3. Hidden layer {% latex %}A \in (4, 1){% endlatex %}

To perform forward propagation, we have the following calculation:

- {% latex %}z^{[1]} =  W^{[1]} x^{(i)} + b^{[1]}{% endlatex %}
- {% latex %}a^{[1]} = \tanh(z^{[1]}){% endlatex %}
- {% latex %}z^{[2]} = W^{[2]} a^{[1]} + b^{[2]}{% endlatex %}
- {% latex %}\hat{y}^{(i)} = a^{[2]} = \sigma(z^{[2]}){% endlatex %}
- If {% latex %}a^{[2]} > 0.5 {% endlatex %} then {% latex %}\hat{y}^{(i)} = 1{% endlatex %}, otherwise {% latex %}\hat{y}^{(i)} = 0{% endlatex %}.

Given that we have computed {% latex %}A^{[2]}{% endlatex %}, which contains {% latex %}a^{[2](i)}{% endlatex %} for every example, we can compute the cost function as follows:

- {% latex %}J = - \frac{1}{m} \sum\limits_{i = 0}^{m} \large{(} \small y^{(i)}\log\left(a^{[2](i)}\right) + (1-y^{(i)})\log\left(1- a^{[2](i)}\right) \large{)} \small{% endlatex %}

Given the loss function, we want to implement the **backward propagation** starting from {% latex %}z_{2}{% endlatex %} back to {% latex %}z_{1}{% endlatex%}:

- {% latex %}dz^{[2]} = a^{[2]} - y{% endlatex %}
- {% latex %}dW^{[2]} = dz^{[2]}(a^{[1]})^{T}{% endlatex %}
- {% latex %}db^{[2]} = dz^{[2]}{% endlatex %}
- {% latex %}dz^{[1]} = (W^{[2]})^{T}dz^{[2]} * g^{[1]'}(z^{[1]}){% endlatex %}
- {% latex %}dW^{[1]} = dz^{[1]}x^{T}{% endlatex %}
- {% latex %}db^{[1]} = dz^{[1]}{% endlatex %}

Then we use **gradient descent** to calculate {% latex %}W^{[1]}{% endlatex %}, {% latex %}b^{[1]}{% endlatex %} and {% latex %}W^{[2]}{% endlatex %}, {% latex %}b^{[2]}{% endlatex %}, with a specified **learning rate** {% latex %}\alpha{% endlatex %}:

- {% latex %}W^{[1]} = W^{[1]} - \alpha * dW^{[1]}{% endlatex %}
- {% latex %}b^{[1]} = b^{[1]} - \alpha * db^{[1]}{% endlatex %}
- {% latex %}W^{[2]} = W^{[2]} - \alpha * dW^{[2]}{% endlatex %}
- {% latex %}b^{[2]} = b^{[2]} - \alpha * db^{[2]}{% endlatex %}

After one iteration of the loop is finished, we then run the model again with the training set, and we expect to see the value of **loss function** descreases.

## L-layer neural network

A l-layer neural network follows the same logical loop as the 2-layer neural network, however activation function for the hidden layers is different.

Rather than using {% latex %}tanh{% endlatex %} as the activation function, in recent years people have started using [rectified linear function](https://en.wikipedia.org/wiki/Rectifier_(neural_networks)), ReLU for short. ReLU has two advantages, first is that it is a non-linear function so it provides the similar benefit as other non-linear function such as {% latex %}tanh{% endlatex %} or {% latex %}sigmoid{% endlatex %}. Also, the derivative of ReLU is a constant, making it much faster when calculating the backward propagation step.

In addition, we need to make sure we initialize **non-zero values** for {% latex %}W^{[1]}{% endlatex %}. if {% latex %}W^{[1]}{% endlatex %} is a vector of zeros, then the forward and backward propagation will effectively update parameters during each iteration, making the model ineffective.

![L layer propagation](/images/L-layer-propagation.png)

Following the general pattern of building the neural network, we can specify the input parameters in mathmatical terms:

- We have {% latex %}L{% endlatex %} layers with input layer {% latex %}X{% endlatex %} and output layer {% latex %}Y{% endlatex %}.

The forward propagation is computed using following equations:

- The first activation layer: {% latex %}Z^{[1]} = W^{[1]}X + b^{[1]}{% endlatex %}, {% latex %}A^{[1]} = ReLU(Z^{[1]}){% endlatex %}
- The nth activation layer: {% latex %}Z^{[n]} = W^{[n]}A^{[n-1]} + b^{[1]}{% endlatex %}, {% latex %}A^{[n]} = ReLU(Z^{[n]}){% endlatex %}
- The last activation layer: {% latex %}Z^{[L]} = W^{[L]}A^{[L-1]} + b^{[1]}{% endlatex %}, {% latex %}A^{[n]} = sigmoid(Z^{[L]}){% endlatex %}

Next we want to implement the loss function to check if our model is actually learning:

{% latex %}-\frac{1}{m} \sum\limits_{i = 1}^{m} (y^{(i)}\log\left(a^{[L](i)}\right) + (1-y^{(i)})\log\left(1- a^{[L](i)}\right)){% endlatex %}

Then we calculate the backward propagation, which follows steps similar to forward propagation:

- linear backward
- linear to activation backward where activation computes the derivative of {% latex %}ReLU{% endlatex %} or {% latex %}sigmoid{% endlatex %} activation
- [linear to {% latex %}ReLU{% endlatex %}] X (L-1) to Linear to {% latex %}sigmoid{% endlatex %} backward (whole model)

For layer {% latex %}l{% endlatex %}, the linear part is: {% latex %}Z^{[l]} = W^{[l]} A^{[l-1]} + b^{[l]}{% endlatex %} (followed by an activation).

Given we have already calculated the derivative {% latex %}dZ^{[l]} = \frac{\partial \mathcal{L} }{\partial Z^{[l]}}{% endlatex %}. We want to get {% latex %}(dW^{[l]}, db^{[l]} dA^{[l-1]}){% endlatex %}.

- {% latex %}dW^{[l]} = \frac{\partial \mathcal{L} }{\partial W^{[l]}} = \frac{1}{m} dZ^{[l]} A^{[l-1] T}{% endlatex %}
- {% latex %}db^{[l]} = \frac{\partial \mathcal{L} }{\partial b^{[l]}} = \frac{1}{m} \sum_{i = 1}^{m} dZ^{[l](i)}{% endlatex %}
- {% latex %}dA^{[l-1]} = \frac{\partial \mathcal{L} }{\partial A^{[l-1]}} = W^{[l] T} dZ^{[l]}{% endlatex %}

Now that we have {% latex %}(dW^{[l]}, db^{[l]} dA^{[l-1]}){% endlatex %}, we can update our parameters using gradient descent:

- {% latex %}W^{[l]} = W^{[l]} - \alpha \text{ } dW^{[l]}{% endlatex %}
- {% latex %}b^{[l]} = b^{[l]} - \alpha \text{ } db^{[l]}{% endlatex %}

Similar to 2 layer neural network, after one iteration of the loop is finished, we then run the model again with the training set, and we expect to see the value of **loss function** descreases.

