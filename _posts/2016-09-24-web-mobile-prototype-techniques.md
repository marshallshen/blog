---
layout:     post
title:      Web / Mobile prototype techniques
date:       2016-09-24
categories: blog
tags: ["design", "prototype"]
blog: true
---

In general, prototyping goes through the following phases: ideation, wire framing, and development. Each stage has its objectives. A good ideation process is collaborative, a good wireframing process is iterative, and a good development process is simplistic.

## Collaborative Ideation


Ideation sorts out relevant information on ideas. Before ideation, a new includes many open questions. For example, in building an Airbnb search page, the initial problem might be presented as the following:

> As a user, I want to be able to find a place to stay for my upcoming trip.

This sentence indicates several directions to explore. First, “user” is an ambiguous term, clarifying questions on demographics helps identify stakeholders. Second, the user need is vague, questions like the type of places and the type of trips must be addressed.

*Identify personas around stakeholders*. Build a persona as concrete as possible. It's best if real stakeholders are present during the prototyping process. Set up persona profile, a profile may look something like this:

![personal](/images/persona.png)

*Conduct User Interview*. After identifying stakeholders, schedule interviews with them. The goal is to gain insights on user behavior. Doing a successful user interview takes practice, there are several practical and mental toolkit that can make us successful.

*Stay focused on the goal*. Understand what to study before the interview, and pay attention to any information that helps achieve that goal.

*Brainstorm, then consolidate interview questions*. Try to come up with as many relevant questions as possible, then cut the questions based on a time limit.

*Be early, end early. Be courteous of interviewee’s time*. Interviewers should be well-prepared and make use of the interviewee's time.

*Asking why during the interview*. Use a laddering technique to gain insights into user behavior. For example, an exchange of user interview may look something like the following:

  Q: What place do you want to stay at?
  A: I want to stay at someone’s private home for my travel.
  Q: Why do you want to stay at someone’s private home?
  A: Because I want to meet some interesting local people.
  Q: Why do you want to meet some interesting local people?
  A: Because I want to feel the culture at the place and experience local lifestyle.
  Q: Why is it important to experience local lifestyle?
  A: Because I want to feel belonged to the local community during my time of travel.

After asking "why," the interview finding went from vacation preference to the sense of belonging.

Be non-judgmental. Some answers from users might be different from how interviewer perceives the world. It’s a skill to be non-judgmental. Keep in mind that everyone has different perspectives, and different perspectives help build better products.

Map out user flows by using a story map. It tells people’s reaction, action, and feelings at important points during an experience. In a way, it’s storytelling of interaction between the users and the product. A journey map may look like this:

![journey_map](/images/journey_map.png)

## Iterative Wireframing

After ideation, turn the ideas into concrete mock-up screens. At this stage, it is still ambiguous what the final screens  look like. Any good design needs to be evaluated in various ways and improve over time. Good wireframing, like any other good design, requires multiple rounds of evaluation and improvement. A few actions can make the process productive.

*Sketch multiple versions of screens.* Treat the sketch as brainstorming based on more relevant information from ideation. Try to build a product from different perspective using the information from ideation. Another benefit of providing multiple versions is that it gets less personal. When the team discuss different versions of sketches, feedback is less personal and more towards the goal of building a good product.

*Brainstorm sketch based on user flow.* Start with the big picture of user flow. Think about the intention of users, interaction between users and the product, and outcome of the interaction.

*Start with a paper prototype.* It’s unnecessary to invest energy in details from the get-go because details will change. Use pen and paper, encourage the whole team to participate. It doesn’t matter if someone is a good drawer, paper prototyping lets ideas out of the head and put them into reality. A mobile paper prototype may look like this:

![paper_prototype](/images/paper_prototype.png)

*After paper prototype, consolidate screens into a low-fidelity prototype.* Identify and prioritize key features from the paper prototype, and put them into a few black-white digital mockup screens. A black-white digital mockup screen is called low-fidelity screen, and a web low-fidelity screen can look like this:

![low_fidelity](/images/low_fidelity.png)

*Turn low-fidelity prototype into high fidelity prototype.* A low-fidelity prototype should show user flow and key features of a product. A high-fidelity incorporates designs details like color and fonts; it looks and feels like a real product, and it can generate more feedback. A mobile high-fidelity prototype can look like this:

![high_fidelity](/images/high_fidelity.png)

## Simplistic Development

After high-fidelity screens, designers hand over screens to developers. During the development stage, designers and developers collaborate to build out a front-end prototype, with minimal support of back-end. Several practices can increase productivity at this stage.

*Frequent design feedback.* Developers may pay attention to code quality but ignore design details of screens. When a screen is coded out, ask the designer for feedback, which ensures the visual quality of the product.

*Design matters.* Keep the mindset of “design matters” in the course of development. Many developers pay attention to code quality but tend to ignore visual details of a screen (e.g. color, paddings of a button, etc). For a quality product, the design must be of high priority. It’s an important mindset change for any developer who wants to build quality products.

*Divide and conquer.* Approach a complicated screen with simplicity in mind. Break down development tasks into achievable sub-tasks, keep each subtask simple and focus on them in order.

  - Overall layout.
  - Identify different UI component.
  - Develop each component.

For example, to develop for a mobile screen below.

![development](/images/prototype_development.png)

  - Overall layout. The screen has a top navigation, a bottom navigation, and a body with lists and filters.
  - Identify different UI components. It has four main components: a top navigation, a bottom navigation bar, a list filter, and a list view.
  - Develop each component. The techniques of developing those components is its own post; one suggestion is to realistic mock data. It helps developers get a sense of what the prototype will look like in production.

Prototyping a new product is fun! There are many great techniques, and this post is just a tiny collection from my humble experience.

