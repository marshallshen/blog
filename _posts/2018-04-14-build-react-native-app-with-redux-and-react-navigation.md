---
layout:     post
title:      build react native app with redux and react navigation
date:       2018-04-14
categories: blog
tags: ["react native", "mobile"]
blog: true
---

![](/images/broker-notes.png)

## First Principle

Mobile development centers around User Experience with a limited amount of space estate. Two key areas of mobile development are *navigation* and *data management*. Regardless of development frameworks and devices types, mobile app makers need to address the questions on behalf of users:

1. How can I have great navigation experience within the app?
2. How can I load information the moment I need it?

Inside React Native framework, [Redux](https://redux.js.org) is a powerful tool for *data management* and [React Navigation]() is a powerful tool for *navigation*.


## Start with data

In this blogpost I dive into designs of [Broker Notes](https://broker-notes.com), a React Native app that is built with Redux and React Navigation. All the data management is handled by Redux, including React Navigation. One thing to keep in mind, **navigation is a data point we need to management within the app**. Broker notes is a quiz app built for people who study to become a Real Estate agent in the United States. A user can select what topics she wants to practice with quiz, and how many questions she wants inside a quiz.

Redux is a state management library following [Flux pattern](https://github.com/facebook/flux/blob/master/examples/flux-concepts/README.md), it makes an app behaves consistently by following design conventions including proper state transitions and data immutability. Within React Native, middleware libraries are available to make development and monitoring easy.

The store is composed of `actions` and `reducers`. Referenced from Redux official docs:

> **Actions** are payloads of information that send data from your application to your store. They are the only source of information for the store. You send them to the store using store.dispatch().

> **Reducers** specify how the application's state changes in response to actions sent to the store. Remember that actions only describe the fact that something happened, but don't describe how the application's state changes.

Translating the business to technical design, we need to `topics` and `numberOfQuestion` inside a quiz. The actions a user can perform within an app is:

- select a topic
- select number of questions

In our app, we make a directory **actions/** and create a file **actions/index.js**:

```javascript
import * as types from '../constants/ActionTypes'

export const newQuiz = () => ({ type: types.NEW_QUIZ })
export const nextQuestion = () => ({ type: types.NEXT_QUESTION })
export const previousQuestion = () => ({ type: types.PREVIOUS_QUESTION })
export const reviewQuiz = () => ({ type: types.REVIEW_QUIZ })
export const showNationalTopics = () => ({ type: types.SHOW_NATIONAL_TOPICS })
export const showStateTopics = () => ({ type: types.SHOW_STATE_TOPICS })
export const selectOption = option => ({ type: types.SELECT_OPTION, option })
export const selectNationalTopic = selectedNationalTopic => ({ type: types.SELECT_NATIONAL_TOPIC, selectedNationalTopic })
export const selectStateTopic = selectedStateTopic => ({ type: types.SELECT_STATE_TOPIC, selectedStateTopic })
export const startQuiz = () => ({ type: types.START_QUIZ })
export const updateTotalQuestionNumber = (totalQuestionNumber) => ({ type: types.UPDATE_TOTAL_QUESTION_NUMBER, totalQuestionNumber})
export const updateNumber = () => ({ type: types.UPDATE_NUMBER })
```

Inside **constants/ActionTypes**, we whitelist all the actions the app should know about:

```javascript
export const NEXT_QUESTION = 'NEXT_QUESTION'
export const NEW_QUIZ = 'NEW_QUIZ'
export const PREVIOUS_QUESTION = 'PREVIOUS_QUESTION'
export const REVIEW_QUIZ = 'REVIEW_QUIZ'
export const SELECT_OPTION = 'SELECT_OPTION'
export const SELECT_NATIONAL_TOPIC = 'SELECT_NATIONAL_TOPIC'
export const SELECT_STATE_TOPIC = 'SELECT_STATE_TOPIC'
export const SHOW_NATIONAL_TOPICS = 'SHOW_NATIONAL_TOPICS'
export const SHOW_STATE_TOPICS = 'SHOW_STATE_TOPICS'
export const START_QUIZ = 'START_QUIZ'
export const UPDATE_TOTAL_QUESTION_NUMBER = 'UPDATE_TOTAL_QUESTION_NUMBER'
export const UPDATE_NUMBER = 'UPDATE_NUMBER'
```

Then we have a separate **reducers** folder and create a **reducers/quiz.js**, note that `quiz` is going to be one redux store in our app, `navigation` being the other one.

```javascript
import * as types from '../constants/ActionTypes'

const initialState = {
  numberOfQuestions: 10,
  totalQuestionNumber: 10,
  totalCorrectQuestionNumber: 0,
  currentQuestionNumber: 0,
  reviewQuiz: false
};

const quizReducer = (state = initialState, action) => {
  switch (action.type) {
    case types.NEW_QUIZ:
      return initialState;
    case  types.NEXT_QUESTION:
      return {
        ...state,
        currentQuestionNumber: state.currentQuestionNumber + 1,
      };
    case types.PREVIOUS_QUESTION:
      return {
        ...state,
        currentQuestionNumber: state.currentQuestionNumber - 1,
      };
    case types.REVIEW_QUIZ:
      return {
        ...state,
        currentQuestionNumber: 0,
        reviewQuiz: true,
      }
    case types.SELECT_NATIONAL_TOPIC:
      return {
        ...state,
        showNationalTopics: true,
        showStateTopics: false,
        selectedNationalTopic: action.selectedNationalTopic
      }
    case types.SELECT_STATE_TOPIC:
      return {
        ...state,
        showNationalTopics: false,
        showStateTopics: true,
        selectedStateTopic: action.selectedStateTopic
      }
    default:
      return state;
  }
};

export default quizReducer
```

I like to think about reducers in two parts - `state` where data is stored and `reducer(state, action)` where the `state` gets copied and the updated object gets updated when a certain action is triggered. It follows a pattern below:

```javascript
const initialState = { stateOne: "one", stateTwo: "two" }
const someReducer = (state = initialState, action) = {
  switch(action.type) {
    case "action_type_one":
      // return a cloned copy of state and updates
    case "action_type_two":
      // return a cloned copy of state and updates
    default:
      return state
  }
}
```

We can put more data into **actions/index.js**, and it is highly customizable. The `actions` provides the mapping of methods and params for data manipulation and `reducers` is the place where state transition actually happens.

Now that we have `actions` and `quizReducer` setup, we can merge the `quizReducer` into a master reducer, we create a separate **reducers/index.js**:

```javascript
import { combineReducers } from 'redux'
import quizReducer from './quiz'

export default reducer = combineReducers({
  quiz: quizReducer,
})
```

Later on we will add another navigation reducer so that we can treat navigation as data. In addition, using `combineReducers` introduces namespace for fetching states and dispatching actions from different stores. For instance, we have a component `Question` that uses `quizStore`, a simplified version of that component looks like below:

```javascript
import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Text, View, ScrollView, Alert } from 'react-native';
import { CheckBox, Button } from 'react-native-elements';

import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import * as actions from '../actions';

class Question extends Component<{}> {
  render() {
    return (
      <View style={{ flex: 1, backgroundColor: 'white'}}>
        <ScrollView>
          <View}>
            <Text>
              {this.props.question.question}
            </Text>
          </View>
        </ScrollView>
      </View>
    );
  }

}

Question.propTypes = {
  question: PropTypes.shape({
    question: PropTypes.string.isRequired,
    options: PropTypes.array.isRequired,
    tip: PropTypes.string,
  })
}

const mapStateToProps = state => ({
  currentQuestionNumber: state.quiz.currentQuestionNumber,
  question: state.quiz.questions[state.quiz.currentQuestionNumber],
  totalQuestionNumber: state.quiz.totalQuestionNumber,
  totalCorrectQuestionNumber: state.quiz.totalCorrectQuestionNumber,
})

const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators(actions, dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(Question)
```

Notice that inside `mapStateToProps`, each state is suffixed with **quiz** (e.g. state.quiz.currentQuestionNumber). This is a result `combineReducers` and that we deliberately fetch state from proper store.

Now that we have our `Question` component, we can simply include it in our **App.js**. On the App component, we call `createStore` using the defined reducers before, and wrap the component within `<Provider>` component by React Redux:

```javascript
import React, { Component } from 'react';
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import { Platform, StyleSheet, View, ScrollView, StatusBar } from 'react-native'
import Question from './components/Question'

import reducer from './reducers'

const store = createStore(reducer)

export default class App extends Component<{}> {
  render() {
    return (
      <Provider store={store}>
        <Question />
      </Provider>
    );
  }
}

```

## Add navigation

Now that we have store for our app-related data, we want to have a store for our app-wide navigator. [React Navigation](https://reactnavigation.org/) is a data structure that hosts the states of navigation of your app. It also provides some built-in methods such as `navigation` and `statesForAction`.

We will create a component `AppNavigator` that functions like a router for all components. The app-related components will be wrapped inside this component so that they are "aware" of the routing and are able to update the navigation state, here we also rely on `react-navigation-redux-helpers` to connect the dots between redux and react navigation:

```javascript
import React from 'react'
import { addNavigationHelpers, StackNavigator } from 'react-navigation'
import {
  createReactNavigationReduxMiddleware,
  createReduxBoundAddListener
} from 'react-navigation-redux-helpers'
import { createStore, combineReducers } from 'redux'
import { connect } from 'react-redux'

import Dashboard from './Dashboard'
import Summary from './Summary'
import Question from './Question'

export const AppNavigator = StackNavigator({
  dashboard: { screen: Dashboard },
  quiz: { screen: Question },
  summary: { screen: Summary }
}, {
  initialRouteName: 'dashboard',
  headerMode: 'screen'
});

// Note: createReactNavigationReduxMiddleware must be run before createReduxBoundAddListener
const navigationMiddleware = createReactNavigationReduxMiddleware("root", state => state.nav)
const addListener = createReduxBoundAddListener("root")

const AppWithNavigationState = ({ dispatch, nav }) => (
  <AppNavigator navigation={addNavigationHelpers({ dispatch, state: nav, addListener, })} />
);

const mapStateToProps = state => ({
  nav: state.nav,
});

export default connect(mapStateToProps)(AppWithNavigationState);
```


Then we can create a reducer just for the navigation: **reducers/navigation.js**:

```javascript
import { NavigationActions } from 'react-navigation'
import { AppNavigator } from '../components/AppNavigator'

const router = AppNavigator.router;
const initalAction = router.getActionForPathAndParams('dashboard')
const initialState = router.getStateForAction(initalAction)

export default navigationReducer = (state = initialState, action) => {
  let nextState;

  switch (action.type) {
    case 'Quiz':
      nextState = router.getStateForAction(
        NavigationActions.navigate({ routeName: 'quiz' }),
        state
      )
      break;
    case 'Summary':
      nextState = router.getStateForAction(
        NavigationActions.navigate({ routeName: 'summary' }),
        state
      )
      break;
    case 'Dashboard':
      nextState = router.getStateForAction(
        NavigationActions.navigate({ routeName: 'dashboard' }),
        state
      )
      break;
    default:
      nextState = AppNavigator.router.getStateForAction(action, state);
      break;
  }

  return nextState || state
}
```

Inside **reducers/index.js**, we need to add the navigation reducer:

```javascript
import { combineReducers } from 'redux'
import navigationReducer from './navigation'
import quizReducer from './quiz'

export default reducer = combineReducers({
  nav: navigationReducer,
  quiz: quizReducer,
})
```

Lastly, rather than rendering `Question` within the **App.js**, we will render **AppNavigator.js**

```javascript
import React, { Component } from 'react';
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import { Platform, StyleSheet, View, ScrollView, StatusBar } from 'react-native'
import AppWithNavigationState from './components/AppNavigator'

import reducer from './reducers'

const store = createStore(reducer)

export default class App extends Component<{}> {
  render() {
    return (
      <Provider store={store}>
        <AppWithNavigationState />
      </Provider>
    );
  }
}
```

## Final thoughts

This post outlined the general structure of building a React Native app with Redux and React Navigation. You can find the realized product on [Google Play Store](https://play.google.com/store/apps/details?id=io.chefy.brokernotes) and [iTunes](https://itunes.apple.com/us/app/broker-notes/id1351101355?mt=8). Beyond development, using Redux for state management helps testing because in the test we can "mock" the state of the app and verifies that the app renders properly. I'm also experimenting with combing Redux and [AsyncStorage](https://facebook.github.io/react-native/docs/asyncstorage.html) and understand how to structure a sizable mobile app using both.
