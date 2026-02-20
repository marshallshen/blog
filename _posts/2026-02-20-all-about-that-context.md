---
layout: post
title: "All About That Context"
tags: ["essay", "ai"]
---

I've been working with AI agents for months now. I've learned their strengths, their quirks, how to prompt them effectively. But no matter how good my prompts get, I keep hitting the same wall: agents don't remember.

Every conversation starts from zero. Every task begins with me explaining the same context again. And again. And again.

The problem isn't prompting. The problem is memory.

Or rather, the lack of it.

## The Limits of Prompting

You can craft the perfect prompt. Clear instructions, specific examples, precise constraints. It works beautifully—for that one task.

Then you start a new task. You need to explain everything again. The project structure. The coding standards. The business logic. The edge cases you've already discussed.

Prompting alone can't solve this. Because prompting assumes the agent has the context it needs. But agents have no long-term memory. They only know what you tell them right now.

This is the fundamental constraint we're working within.

## The Human Parallel

Here's what struck me: this is exactly how human cognition works too.

Your brain doesn't load everything it knows into active memory all the time. That would be overwhelming. Instead, it zooms in on relevant context when performing specific tasks.

When you're cooking, you don't simultaneously access your knowledge of calculus, your childhood memories, and your understanding of Roman history. You load in what matters: recipes, ingredient properties, timing, technique.

Context switching is how we function. We focus on what's relevant for the task at hand.

Agents need the same thing. Not all the context all the time. Just the right context at the right moment.

## Knowledge Folders

I'm building this into my workflow using the Diastras framework.

Before an agent starts a task, it loads specific knowledge documents. Think of these as context primers—targeted information packages that help the agent zoom in and understand what matters for this particular job.

For example:
- **Code review task**: Load coding standards, common pitfalls, project architecture patterns
- **Writing task**: Load voice guidelines, previous examples, topic-specific research
- **Design task**: Load design system rules, brand guidelines, user research insights

Each knowledge folder contains only what's needed for that type of work. Not everything. Just what helps the agent contextualize and perform better.

## How It Works in Practice

The workflow looks like this:

1. **Identify the task type**: What kind of work is this?
2. **Load relevant knowledge**: Pull in the context documents that matter
3. **Execute with context**: Agent now has the background it needs
4. **Build the knowledge base over time**: Each project adds to the folders

The key insight: you don't need agents to remember everything forever. You need them to access the right context at the right time.

This is exactly how your brain works. And it's incredibly effective.

## What I've Learned So Far

This approach has fundamentally changed how I work with agents.

**Before knowledge folders:**
- Every task required extensive context in the prompt
- I'd forget to mention critical constraints
- Results were inconsistent because context varied
- I spent more time briefing than reviewing

**After knowledge folders:**
- Tasks start with relevant context already loaded
- Critical information is documented and reusable
- Results are more consistent across similar tasks
- I focus on the specific task, not re-explaining fundamentals

The difference isn't marginal. It's transformative.

## Building Your Own Context System

You don't need a fancy framework to start. The principle is simple:

**Document the knowledge that specific types of tasks need.**

Start small:
- Create a folder for your most common agent task
- Write down the context that task requires
- Have agents load that context before starting
- Refine and expand over time

The framework I'm using (Diastras) helps orchestrate this, but the core idea works with any system. The magic is in the knowledge folders themselves, not the tooling.

I've made my [conductor files publicly available on GitHub](https://github.com/marshallshen/conductor_files) so you can see what this looks like in practice. For example, here's the [tech doc writer agent configuration](https://github.com/marshallshen/conductor_files/blob/main/agents/tech-doc-writer.md)—it shows exactly what context gets loaded for technical writing tasks.

## Why This Matters

We're at an inflection point with AI agents. They're capable enough to handle complex work, but working with them still feels clunky.

The bottleneck isn't agent capability. It's context management.

Humans have solved this problem through specialization and documentation. Doctors don't re-learn medicine before each patient—they access specialized knowledge when needed. Engineers don't memorize every API—they reference documentation in context.

Agents need the same thing. Not omniscience. Just relevant context at the right moment.

## The Pattern I'm Betting On

I think knowledge management will become the killer feature for agent systems.

Not bigger context windows. Not better memory retention. Not more sophisticated prompting.

**Smarter context loading.**

The agent that knows what it needs to know, when it needs to know it, will outperform the agent trying to remember everything or starting from scratch every time.

This mirrors how the best human teams work. Clear documentation. Shared knowledge bases. Context-appropriate information flow.

## Where I'm Going Next

I'm continuing to build out knowledge folders for different task types. The more I document, the more effective my agents become.

But the deeper insight is this: **working effectively with agents isn't about better prompting. It's about better context architecture.**

How do you structure knowledge so it's accessible when needed? How do you chunk information so agents can zoom in appropriately? How do you build systems that grow smarter over time?

These are the questions I'm exploring.

Because it's all about that context. And getting context right changes everything.
