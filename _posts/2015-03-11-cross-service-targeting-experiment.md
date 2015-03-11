---
layout:     post
title:      Cross Service targeting experiement
date:       2015-03-11
summary:    How does Google use data within services to target outside services
categories: blog
---

### What is the question
  Our online personal information has been increasingly exploited, but users have little knowledge on how their data is used.
  Our research investigate on Google on how it uses user data, specifically, we attempt to address the following:

  > Does Google use user data within services to target outside services? If so, how?

### From question to experiment
  The compound question came with few concepts - **data within services** is any set of data collected from Google services, such as Gmail accounts, Youtube searchs, etc; **outside services** are websites that are not supervised by Google, such as Wall Street Journal, the Economist, etc.

  Two questions can be asked: first, can we find any evidence that what users do within Google service affects what users see on outside services; second, can we find a flow that shows the effect.

  Our goal of experiment is to find any `statistically significant hypothesis`, and the hypothesis is related to `targeting personal data`.  To further narrow down the direction of investigation, experiments have been designed to achieve two different goals:

  1. __Exploratory experiment__: find signals that a hypothesis is valid on certain inputs and outputs.
  2. __Validation experiment__: given a signal of valid hypothesis, refine the set of inputs and outputs, run further experiments.

  Each type of experiment has a consistent variables:

  * __Profiles__: represents user information, for example, a Google account can a profile
  * __Inputs__: represents a particular profile-dependent activity within Google services
  * __Outputs__: represents a particular profile-dependent outcome from external services
  * __Uncontrolled Variables__: represents variables that may affect experimental results, but not within our experiment interests (IP, timestamp, etc.).

  Based on consistent variables, our experiments generated a set of __hypotheses__ to represent relationships that link inputs and outputs.

  Let's see how we can conduct *exploratory experiment* for *cross service targeting*, specifically, we want to test the following hypothesis:

  > Google uses `Youtube searches` to  `personalize ads` on external websites.

  In our study, start by exploratory experiments, we model experiments for hypothesis aboave as follows:

  * __Profiles__: a set of registered Google accounts, with no previous account activities
  * __Inputs__: a set of search terms (i.e. finance, cancer, dog..).
  * __Outputs__: a set of ads appeared on external websites (context sites) - such as Time of India, Wall Street Journal.
  * __Uncontrolled Variables__: timestamp of when experiment was run, IP from which requests are made.
  * __Hypothesis__: a *causal relationship* for given input and output. An example case from which a hypothesis can be established:

  > Given a profile P1 has input ("finance" I1) on Youtube
  And profile sees an ad O1 (from WSJ on "Wolf of Wall Street")
  Then a hypothesis is I1 causes O1 shown

### Run experiments on scale
  To detect a targeting signal cross service, we believe that we must run large-scale experiments in parallel. This requires us to further design an experiment service **Hubble** and  **a set of standardized API** required for a valid experiment.

  For cross service experiments, intuitively the following steps are needed:

    1. Specify inputs, profiles to launch an experiment
    2. For given input and profile, record outputs as observations
    3. When observations for a given input and output have been collected sufficiently, launch hypothesis testing

  Hubble provides templates of standardized methods and callbacks for necessary experiment steps, the following pseudocode describes how cross service experiment fits in Hubble experiment workflow

        Experiment CrossService {
          function runExperiment{
            expr_id = createNewExperiment()
            input_ids = getIdsForAllSearchTerms()
            profile_ids = getIdsForAllGoogleAccounts()

            // Hubble API
            collectingJobs = Hubble.registerExperiment(expt_id, input_ids, profile_ids)

            // Local code, run asynchronous in workers, evoked by Hubble
            for input_id, profile_id in collectingJobs {
              output_id = collectData(input_id, profile_id)
              // Hubble API - count given unique key (expt_id, output_id, uncontrolled_vars
              addObservations(expt_id, output_id, input_ids, unconrolled_vars, count)
              if (passThreshold(output_id)) notifySufficientObservation(expt, output_id)
            }

          }

          function collectData(input_id, profile_id)
          function notifySufficientObservation(expt_id, output_id) {
            // Notify Hubble observation is sufficient
          }
          function passThreshold(output_id) {
            // threshold parameter specific for each experiment
          }

        }

        Service Hubble {
          function registerExperiment(expt_id, input_ids, profile_ids)
          function onObserationNotification(expt_id, output_id)
          function addObservation(expt_id, output_id, input_ids, uncontrolled_vars, count)

          // used in validation experiments
          function addHypothesis(expt_id, output_id, input_ids, confidence)
        }


