---
layout:     post
title:      Testing with Vue.js
date:       2017-08-28
categories: blog
tags: ["Javascript", "Vue.js"]
blog: true
---

For the past year I have been on the team building progressive web application (PWA) using [Vue.js](http://vuejs.org). The framework is relatively new, so there is not a standard guideline on how to properly test a large scaled Vue application.

If you are building a large PWA with Vue.js as the frontend framework, I hope you find this blogpost useful. In this post I will share some of our learning lessons and pragmatical guidelines our team come up in tesing with Vue.js.

## Challenge of scaling

It all starts with the growing pain. As we keep adding components to our frontend, we realize that we need to adopt flux architecture and introduce Vuex to scale. As we adpot Vuex and adds more pages to the app, we realize that we need to introduce Vue router to handle more sophisticated rendering. Very soon, our frontend has odd behaviors, our QA start to get confused, and developers start to scream at each other -- okay, maybe not scream, but we were definitely frustrated bunch.

Then comes the natural conversation of **improve code quality**, which leads to the conversation of **add test coverage to our frontend**. So the developers rolled up our sleeves and start to tackle of the problem of writing Javascript tests against a fairly large PWA in Vue. Experiments after another, code review after another, we came up with our solution, yet two thoughts stand true in our discovery, one good, one bad.


## The bad: tooling of Javascript testing

First, let's start with the bad. Regardless of which Javascript framework we use, when it comes to frontend testing, there are many ala carte solutions out there, each may solve one aspect of testing very well, but none excel in all aspects of testing. Before we start building our own Javascript testing procedure, we come up with a checklist of what functionality we want when running the tests. Below is a list and what we settled on.

| Tool            | Why do we need it   | What do we use                 |
|-----------------|:-------------------:|-------------------------------:|
| Pakcage manager | Manage all the jascript and css dependencies| [Webpack](https://webpack.github.io/), [Yarn](https://yarnpkg.com/en/), and [Rails asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html)|
| Test runner     | Run Javascript in real or headless browser; allow debugging | [Karma](https://karma-runner.github.io/1.0/index.html)|
| Assertion | Allow various assertion inside tests| [Chai.js](http://chaijs.com/) |
| Mocks and stubs | Stub out method calls, capture method calls and arguments, stub out ajax calls | [Sinon](http://sinonjs.org/) | 

As you can see, the testing solution we come up feels piece-meal, which reflects the fragmented nature of Javascript testing framework. Within Vue.js community people have been working on Vue specific testing framework, but as of the time of this writing, the project is fairly young. 

A sample test inside the app looks like below, the `describe` and `it` blocks are provided by **Karma.js**. The `expect` clause is provided by **Chai.js**. Note that this piece-meal solution should also apply to other frameworks such as [Angular](https://angularjs.org/) and [React](https://facebook.github.io/react/).

```javascript
describe("formatDates", () => {
  const app = window.app
  const expect = window.chai.expect
  const subject = window.app.mixins.formatDates
  const moment = window.moment

  describe("#formatDate", () => {
    it("returns a date formatted as MM.DD.YYYY", () => {
      const date = moment().format()
      const formattedDate = moment.utc(date).format("MM.DD.YYYY")
      expect(subject.methods.formatDate(date)).to.eq(formattedDate)
    })
  })

  describe("#formatUtcDate", () => {
    it("returns an utc formatted date", () => {
      let startDate = moment().format()
      let value = subject.methods.formatUtcDate(startDate)
      let formattedDate = moment.utc(startDate).format()
      expect(value).to.eql(formattedDate)
    })
  })
})
```

## The Good: component tests and interaction tests

Okay, let's start with the good thought. We realize that **component-based framework allows us to test our Javascript code differently**. Traditionally, we write `unit test`, `integration test` and `end to end test` around Javascript application. Although those scopes of test might still hold true while testing with Vue, we like to think that we can write two types of tests with Vue.js: **component tests** and **interaction tests**.

At its core, a Vue app is composed of **components and their interactions**, and the ideas below hold true for each component:

1. each component owns its view
2. each component gets its data locally (props) or globally (Vuex)
3. each component handles events by emitting events, or updating local or global data

In a large scale web application, Vue.js follows [flux architecture](https://facebook.github.io/flux/) with core plugin [Vuex](https://github.com/vuejs/vuex) to handle state management, and our tests should leverage the design of flux architecture.

### Component tests

Component tests focus on functionality of a component, which is similar to unit tests. Specifically, we want to verify that:

1. **Data**. A component has correct `data`, `computed property`, `props` loaded at a given life cycle. This may require correct setup of Vuex store, and also the calling of correct lifecylce method such as mount.
2. **Events**. A component can properly handle different events by either **emitting events** or **change data**. This may require correct setup of Vuex store, and properly stubs and spys of event listeners.

![](/images/component_tests.png)

Below is an example of verifying the correct of data.

```javascript
describe("Account Setting Component", () => {
  const Vue = window.Vue
  const Vuex = window.Vuex
  const AccountSettingComponent = window.app.components.AccountSetting
  let vm

  const store = new Vuex.Store({
    state: {
      account: {
        settings: { display_settings: true }
      }
    }
  })

  beforeEach(() => {
    const Ctor = Vue.extend(AccountSettingComponent)
    vm = new Ctor({
      template: "<div id='vue-account-settings-component'></div>",
      propsData: {},
      store: store
    })

    vm.$mount()
  })


  describe("#mounted()", () => {
    it("fetches display settings from the store", () => {
      expect(vm.displaySettings).to.equal(true)
    })
  })
})
```
At the beginning of the test, we explictly require dependencies around **Vue**, including the `Vue`, `Vuex` and the component that we try to render. In addition, we set up **const store** with a JSON object, which we only mock the minimum amount of data (i.e. state) that is required within the test.

Inside `beforeEach()` block we call the constructor of the component by using `Vue.extend`, and `AccountSettingComponent` is nothing but a JSON object, a more detailed doc is [here](https://012.vuejs.org/api/options.html#name). In the end, we can `$mount()` so that the we "activate" the component.

Let's say we want to check the correctness of event handling, we have a method called `handleDisplaySettingToggle` that toggles `display_setting` on and off, we can fire off the event from the component and verify it from data.

```javascript
describe("Account Setting Component", () => {
  const Vue = window.Vue
  const Vuex = window.Vuex
  const AccountSettingComponent = window.app.components.AccountSetting
  const store = window.app.store
  let vm

  beforeEach(() => {
    const Ctor = Vue.extend(AccountSettingComponent)
    vm = new Ctor({
      template: "<div id='vue-account-settings-component'></div>",
      propsData: {},
      store: store
    })

    vm.$mount()
  })

  ...

  describe("#methods", () => {
    describe("handleDisplaySettingsToggle", () => {
      it("toggles display settings", () => {
        vm.handleDisplaySettingsToggle(false)
        expect(vm.displaySettings).to.eql(false)
      })
    })
  })
})


```

### Interaction tests

Interaction tests focus on interactions between components, router and store. This is close to integration test. Specifically, we can verify that:

1. **State change**. An event inside one component dispatches actions to other components or store, resulting state change in other components.
2. **Server client side interaction**. An action dispatched triggers an ajax with specific parameters. Upon receiving expected response from the server, which we can stub out, then the app renders correct data on the view.

![](/images/interaction_tests.png)


```javascript
describe("Interaction tests: account settings and account review", () => {
  const Vue = window.Vue
  const Vuex = window.Vuex
  const AccountSettingComponent = window.app.components.AccountSetting
  const AccountReviewComponent = window.app.components.AccountReview
  let vm

  const store = new Vuex.Store({
    state: {
      account: {
        settings: { display_settings: true }
      }
    }
  })

  beforeEach(() => {
    const Ctor1 = Vue.extend(AccountSettingComponent)
    vm1 = new Ctor1({
      template: "<div id='vue-account-settings-component'></div>",
      propsData: {},
      store: store
    })

    vm1.$mount()

    const Ctor2 = Vue.extend(AccountReviewComponent)
    vm2 = new Ctor2({
      template: "<div id='vue-account-review-component'></div>",
      propsData: {},
      store: store
    })

    vm2.$mount()
  })

  ...

  describe("display_seetings", () => {
    it("toggles display settings", () => {
      vm1.handleDisplaySettingsToggle(false)
      expect(vm2.displaySettings).to.eql(false)
    })
  })
})
```

The key for the interaction test is that both `vm1` and `vm2` share the same `store` so that the state change go through the same store. 

Note that neither **component tests nor interaction tests verifies what is actually rendered on the DOM**. This is the beauty of component-based framework: if a component is populated with correct data and handles events the right way, the view should take care of itself.


