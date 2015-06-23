---
layout:     post
title:      Anatomy of Empathy Dialogue System
date:       2015-05-12
summary:    Can machines converse like our friends?
categories: blog
---

> HAL: I'm afraid. I'm afraid, Dave. Dave, my mind is going. I can feel it. I can feel it. My mind is going. There is no question about it. I can feel it. I can feel it. I can feel it. I'm afraid. Good afternoon, gentlemen. I am an HAL 9000 computer.         "2001: A Space Odyssey."

Human and machine are becoming more integrated. Nowadays, most dialogue systems are engaging and instruction-oriented: they tend to **retrieve user intentions and provide instructions on those intentions**, dominant dialogue systems are well designed and sometimes, hilarious.

![siri_funny](/images/siri_funny.png)

Can we have **real conversations** with machines? Can machine talk to us as our friends?

### A dialogue odyssey
One major feature of a dialogue is the nature of **turn-taking**. For example, in a dialogue between Tom and Jerry, Tom says something, then Jerry says something, and a dialogue flows by two characters taking turns to contribute to a topic. As functional and fun as current dialogue system (Siri) can be, a dialogue between the system and the audience are short, usually one to three turns long.

One major need of a human is to have **meaningful conversations**: to talk to a friend, to share thoughts, stories and feelings. Meaningful conversations are usually long, a lot more than a few turns, to build up contexts, retrieve emotions, and ultimately, make people feel heard.

On one hand, we have built up a sophisticated machine to parse human language; on the other hand, people have the desire to engage in meaningful conversations. One interest question in building a dialogue system thus arise:

> Can we build dialogue systems to engage the audience in meaningful conversations as if the audience is talking to a friend?

One way to measure "I felt heard" is by measure how **empathetic** the conversation partner is, to rephrase the question above:

> Can we build an emphatic dialogue system for the audience (users)?

## Put "empathy" in a dialogue system
Conversation is naturally complex. Writing a system to carry a meaningful conversation is therefore inherently complex. To start off, we begin with a set of questions that need to be addressed:

1. How to **model** empathy in a dialogue system?
2. How to **measure** empathy in a dialogue system?

### How to model empathy
First, what makes a conversation empathetic? In other words, what makes us feel heard? We have all experienced great conversations where sharing becomes spontaneous; words flow naturally, and we **feel great**. The effects of empathy has the following traits (although I'm no linguistic nor psychology expert):

1. Dialogue lasts longer, comparing to a unempathetic dialogue.
2. Audience experience happiness and gratitude.

Second, a dialogue is unique from the linguistic perspective: unlike monologue, the speaker and hearer must constantly establish common ground, the set of things that are mutually believed by both speakers. They need to achieve common ground means that the hearer must ground or acknowledge the speaker’s utterances, or else make it clear that the there was a problem in reaching common ground.

Therefore, we intend to build a dialogue system that:

1. Make a dialogue continue longer, based on a certain threshold of unempathetic dialogue scheme.
2. Aim to make the audience feel gratitude, measured by syntactic parsing of audience's response.
3. Dynamically retrieve emotions, intentions of audience based on dialogue contexts.

To implement based on these principles, we need to rely on more applied concepts in computational linguistics. Two major concepts are **dialogue acts** and **hidden Markov model**.

#### Dialogue Acts
In computational linguistics, [dialogue acts](http://en.wikipedia.org/wiki/Dialog_act) is a categorization of different lines in a conversation. There are many different category schemes proposed. For example, the system proposed by Stolcke and Andreas, in their paper ["Dialogue Act Modeling.."](http://web.stanford.edu/~jurafsky/ws97/CL-dialog.pdf) includes over 20 categories. Another more general category, proposed by Searle, includes five generic types:

| Class of dialogue acts | Meaning                                                                    | Example                                                     |
|----------------------|----------------------------------------------------------------------------|-------------------------------------------------------------|
| Assertive            | committing the speaker to something’s being the case                       | suggesting, putting forward, swearing, boasting, concluding |
| Directive            | attempts by the speaker to the get the addressee to do something           | asking, ordering, requesting, inviting, advising, begging   |
| Commissive           | committing the speaker to some future course of action                     | promising, planning, vowing, betting, opposing              |
| Expressive           | expressing the psychological state of the speaker about a state of affairs | thanking, apologising, welcoming, deploring                 |
| Declarative          | bringing about a different state of the world via the utterance            | I resign, you are fired.                                    |

#### Hidden Markov Model
Think about dialogue as **states**: on the outside, the lines appear in the conversation can be modelled as **explicit states**, or **visible states**. However, there are also **implicit states**, or **hidden states** of dialogue, such as [part-of-speech tags](http://en.wikipedia.org/wiki/Part-of-speech_tagging), sentiments, intentions, so forth. Let's look at a brief analysis of a dialogue from "2001: A Space Odyssey":

    Dr Frank Poole: Well, whaddya think?
    Dave Bowman: I'm not sure, what do you think?
    Dr Frank Poole: I've got a bad feeling about him.
    Dave Bowman: You do?
    Dr Frank Poole: Yeah, definitely. Don't you?

Use **F** as Frank Poole, **D** as Dave Bowman, we can model their dialogue as following:

![markov example](/images/markov_example.png)

We will skip some technical details on how Hidden Markov Model works (you can read more on the [wiki](http://en.wikipedia.org/wiki/Hidden_Markov_model)). In general, hidden Markov model can **track invisible states**. In a dialogue, there are many invisible states we can capture, such as sentiment, or main subject of a conversation, etc.

(Sidenote: Hidden Markov Model is one of the most common model applied in computational linguistics)

Intuitively, we can build a system that includes the five different dialogue acts as five different strategies. Based on the context of the conversation, the system has a hidden Markov model that computes certain dialogue function for a conversation, and each round the system chooses a strategy to respond to the audience. A pseudo algorithm looks like the following:

    message_of_audience = []
    response_to_audience = []

    empathy_model = new EmpathyModel(args*)

    while(conversation_is_ongoing) {
      lastest_audience_message = captureResponse()
      records_of_audience.add(lastest_audience_response)

      empathy_model.computeEmpathyScores(records_of_audience)
      lastest_response = arg(max(empthy_model.scores_by_speec_acts)

      response_to_aduence.add(latest_response)
      output(lastest_response)
    }

### Objective: Empathy
The next challenge in building empathy dialogue system is in the word "empathy". Specifically:

1. How do we measure empathy?
2. How can we measure the success of a system on being more empathetic?

To materialise and measure empathy. We need to establish a **baseline measurement**. One way to build such baseline is to have a dummy system have the same response regardless what the audience says, and we can count the lines of speech audience engage with the dummy system. For example, we can have dummy system to say:

> That's interesting! Please tell me more!

Then we count how many lines an audience engaged with the dummy system on average. After the dummy system is set up, then we can build alternative systems that aim to have more lines of engagement from the audience.

## Conclusion

Computational linguistic is a fascinating yet complicated subject. I write this blog post to outline the big ideas behind [a side project](https://github.com/marshallshen/notebook). Hope you find it interesting, don't hesitate to [contact me](http://mshen.me/contact/) if you have any feedback!

I will also write follow-up posts as more progress made on the project, stay tuned! :)

