---
layout:     post
title:      Testing with Vue.js
date:       2017-08-28
categories: blog
tags: ["Javascript", "Vue.js"]
blog: true
---

For the past year I have been on the team building progressive web application (PWA) using [Vue.js](http://vuejs.org). The framework is relatively new, so there is a standard guideline on how to properly test a large scaled Vue application.

If you are building a large PWA with Vue.js as the frontend framework, I hope you find this blogpost useful. In this post I will share some of our learning lessons and pragmatical guidelines our team come up in tesing with Vue.js.

## Pain of scaling

It all starts with the growing pain. As we keep adding components to our frontend, we realize that we need to adopt flux architecture and introduce Vuex to scale. As we adpot Vuex and adds more pages to the app, we realize that we need to introduce Vue router to handle more sophisticated rendering. Very soon, our frontend has odd behaviors, our QA start to get confused, and developers start to scream at each other -- okay, maybe not scream, but we were definitely frustrated bunch.

Then comes the natural conversation of **improve code quality**, which leads to the conversation of **add test coverage to our frontend**. So the developers rolled up our sleeves and start to tackle of the problem of writing Javascript tests against a fairly large PWA in Vue. Experiments after another, code review after another, we came up with our solution, yet two thoughts stand true in our discovery, one good, one bad.

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

Below is an example of verifying the correct of data.

```javascript
describe("Account TV Ticker Sidebar Modal Component", () => {
  const Vue = window.Vue
  const Vuex = window.Vuex
  const AccountTvSettingsTickerModal = window.app.components.AccountTvSettingsTickerModal
  const testUtils = window.testUtils
  let vm

  const store = new Vuex.Store({
    modules: {
      account: {
        state: {
          accountSettings: { display_ticker: true }
        },
      }
    }

  })

  beforeEach(() => {
    testUtils.stubAjaxCall()
    const Ctor = Vue.extend(AccountTvSettingsTickerModal)
    vm = new Ctor({
      template: "<div id='vue-account-tv-settings-ticker-modal'></div>",
      propsData: {},
      store: store
    })

    vm.$mount()
  })

  afterEach(() => {
    testUtils.unwrapAjaxCall()
  })

  describe("#mounted()", () => {
    it("fetches display_ticker attribute", () => {
      expect(vm.displayTicker).to.equal(true)
    })
  })
})
```
Below is another example of verifying the proper handling of events:

```javascript
describe("Account devices content component", () => {
  const Vue = window.Vue
  const Vuex = window.Vuex
  const VueRouter = window.VueRouter

  // Set up components
  const Account = window.app.components.Account
  const AccountSummary = window.app.components.AccountSummary
  const AccountDevicesContent = window.app.components.AccountDevicesContent

  // Set up store
  const store = new Vuex.Store({
    modules: {
      account: {
        state: {
          salesforce_id: "001Cmarshallmarthers",
        }
      }
    }
  })

  // Set up router
  const router = new VueRouter({
    routes: [
      {
        path: "/accounts/:salesforce_id",
        name: "account",
        component: Account,
        children: [
          {
            path: "details",
            name: "account_details",
            component: AccountSummary,
            meta: {
              breadcrumb: [
                { name: "Home", pathName: "educate" },
                { name: "Account Summary", pathName: "account" },
              ]
            },
          },
          {
            path: "content",
            name: "account_devices_and_content",
            component: AccountDevicesContent,
            meta: {
              breadcrumb: [
                { name: "Home", pathName: "educate" },
                { name: "Account Summary", pathName: "account" },
              ]
            },
          },
        ],
        props: true,
        meta: {
          breadcrumb: [
            { name: "Home", pathName: "educate" },
            { name: "Account Summary", pathName: "account" },
          ],
        }
      },
    ]
  })

  const Ctor = Vue.extend(AccountDevicesContent)

  describe("#mounted()", () => {
    it("returns correct salesforce id", () => {
      let testVm = new Ctor({
        template: "<div id='vue-account-devices-content'></div>",
        propsData: {
          isAccountSettingsModalShown: false,
          isTvSettingsModalShown: false,
          toggles: {
            showCampaignsTable: false,
            showDevicesTable: true,
          },

          tvSettingsToggles: {
            showTicker: false,
            showSidebar: true,
          }
        },

        store: store,
        router: router,
      })

      testVm.$mount()

      expect(testVm.salesforceId).to.equal("001Cmarshallmarthers")
    })

  })

  describe("#handleToggleTvSettingsModals()", () => {
    it("setsTvSettingsToggles", () => {
      let testVm = new Ctor({
        template: "<div id='vue-account-devices-content'></div>",
        propsData: {
          isAccountSettingsModalShown: false,
          isTvSettingsModalShown: false,
          toggles: {
            showCampaignsTable: false,
            showDevicesTable: true,
          },

          tvSettingsToggles: {
            showTicker: false,
            showSidebar: true,
          }
        },

        store: store,
        router: router,
      })

      const tvSettingsToggles = { showTicker: true, showSidebar: false }
      testVm.handleToggleTvSettingsModals(tvSettingsToggles)

      expect(testVm.tvSettingsToggles).to.equal(tvSettingsToggles)
    })
  })

})
```

### Interaction tests

Interaction tests focus on interactions between components, router and store. This is close to integration test. Specifically, we can verify that:

1. **State change**. An event inside one component dispatches actions to other components or store, resulting state change that affects the whole application.
2. **Server client side interaction**. An action dispatched triggers an ajax with specific parameters. Upon receiving expected response from the server, which we can stub out, then the app renders correct data on the view.

```javascript
describe("CampaignAccountPlaylistCampaigns", () => {
  // *** create an instance of the CampaignDetailsEducational component before each test
  // *** rendered in dummy template with dummy props
  const AccountPlaylistCampaigns = window.app.components.AccountPlaylistCampaigns

  const Vue = window.Vue
  const Vuex = window.Vuex
  const store = window.app.store
  const Ctor = Vue.extend(AccountPlaylistCampaigns)

  describe("#tableData", () => {
    it("returns styled table populated with campaignsData", () => {
      const accountDevicesData = [
        {
          "id":"33",
          "type":"android_media_players",
          "attributes":{
            "account_id":1517,
            "asset_id":"t4567",
            "device_type":"AndroidMediaPlayer",
            "status":null,
            "total_campaigns":3,
            "uuid":"ef444e2d1ee80822",
            "device_campaigns":[
              {
                "id":804,
                "name":"Marshall Marthers",
                "intent_type":"educate",
                "specialities":[
                  "Cardiology"
                ],
                "devices":[
                  "t4567"
                ],
                "paused_at":"2016-11-02T21:33:00.000Z",
                "status":"paused",
                "section_type":"main"
              },
              {
                "id":805,
                "name":"Fredric Chopin",
                "intent_type":"educate",
                "specialities":[
                  "Cardiology"
                ],
                "devices":[
                  "t4567"
                ],
                "paused_at": null,
                "status":"active",
                "section_type":"main"
              },
              {
                "id":806,
                "name":"Lauren Keane",
                "intent_type":"educate",
                "specialities":[
                  "Cardiology"
                ],
                "devices":[
                  "t4567"
                ],
                "paused_at":"2017-08-03T22:09:11.000Z",
                "status":"paused",
                "section_type":"main"
              },
            ],
            "campaign_counts":{ "educate":3 },
            "id":33
          }
        }
      ]

      const stubbedStore = new Vuex.Store({
        modules: {
          account: {
            state: {
              accountDevicesData: accountDevicesData
            }
          }
        }
      })

      let testVm = new Ctor({
        template: "<div id='vue-AccountPlaylistCampaigns'></div>",
        propsData: {
          configuration: {}
        },
        store: stubbedStore
      }).$mount()

      const tableData = testVm.tableData
      expect(tableData.length).to.equal(3)

      const firstRow = tableData[0]
      expect(JSON.stringify(firstRow)).to.include("Stopped 11/02/16")

      const secondRow = tableData[1]
      expect(JSON.stringify(secondRow)).to.include("Currently Playing")

      const thirdRow = tableData[2]
      expect(JSON.stringify(thirdRow)).to.include("Stopped 08/03/17")
    })
  })

  describe("#normalizeIntentType", () => {
    it("returns user friendly intent", () => {
      let testVm = new Ctor({
        template: "<div id='vue-AccountPlaylistCampaigns'></div>",
        propsData: {
          configuration: {}
        },
        store: store
      }).$mount()

      expect(testVm.normalizeIntentType("advertise")).to.equal("Sponsorship")
      expect(testVm.normalizeIntentType("educate")).to.equal("Educational")
      expect(testVm.normalizeIntentType("customize")).to.equal("Customization")
    })
  })

})
```

Note that neither component tests nor interaction tests verifies what is actually rendered on the DOM. This is the beauty of component-based framework: if a component is populated with correct data and handles events the right way, the view should take care of itself.

## The bad: tooling of Javascript testing

Regardless of which Javascript framework we use, when it comes to frontend testsing, there are many ala carte solutions out there, each may solve one aspect of testing very well, but none execel in all aspects of testing. Before we start building our own Javascript testing procedure, we come up with a checklist of what functionality we want when runnig the tests. Below is a list and what we settled on.

| Tool            | Why do we need it   | What do we use                 |
|-----------------|:-------------------:|-------------------------------:|
| Pakcage manager | Manage all the jascript and css dependencies| [Webpack](https://webpack.github.io/), [Yarn](https://yarnpkg.com/en/), and [Rails asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html)|
| Test runner     | Run Javascript in real or headless browser; allow debugging | [Karma](https://karma-runner.github.io/1.0/index.html)|
| Assertion | Allow various assertion inside tests| [Chai.js](http://chaijs.com/) |
| Mocks and stubs | Stub out method calls, capture method calls and arguments, stub out ajax calls | [Sinon](http://sinonjs.org/) | 

As you can see, the testing solution we come up feels piece-meal, which reflects the fragmented nature of Javascript testing framework. Within Vue.js community people have been working on Vue specific testing framework, but as of the time of this writing, the project is fairly young. A sample test inside the app looks like below, the `describe` and `it` blocks are provided by **Karma.js**. The `expect` clause is provided by **Chai.js**. Note that this piece-meal solution should also apply to other frameworks such as [Angular](https://angularjs.org/) and [React](https://facebook.github.io/react/).

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


