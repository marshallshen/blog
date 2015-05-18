---
layout:     post
title:      Anatomy of Empathy Dialogue System DRAFT
date:       2015-05-12
summary:    Natural Language Processing
categories: blog
---

## Goals

Interact with audience, to listen to the audience, and maximize empathetic responses during the dialogue.
  1. listen to audience: parse meaning from audience's sentences
      - parse each sentences with a structure that represents meaning
        * Is meaning equal to sentiment in this context?
      - link contexts across sentences:
        * the challenge of references: how to keep track of reference of pronouns?

  2. maximize empathetic responses
      - how to generate empatheitc responses given a meaning representation?
      - how to measure "audience feels heard"?

### Represent sentiment

#### Parse a single sentence
1. Given a sentence, we can perform Part-of-Speech tagging
   - Each entity is then assigned an empathy value (what should system talk about next?)

   Given a sentence, we can perform CFG parsing
   - Question will target a specific constituent (NP, VP, etc)

2. Semantic Analysis - First Order Logic (?)

3. Sentimental analysis

#### Parse multiple sentences:


### Maximize empathy
- Acknowledgements
- Conversational Implicature
- Dialogue Acts

## Architecture Overiew

## Questions and Answers

## TODO
- Integration with Whipser: how to relate empathetic responses together
