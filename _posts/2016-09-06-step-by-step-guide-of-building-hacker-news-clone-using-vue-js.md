---
layout:     post
title:      Build Hacker News clone using Vue.js
date:       2016-09-06
categories: blog
tags: ["Vuejs", "Javascript"]
blog: true
---

`Vue.js` has a sample project of building Hacker News clone using Vue.js, this blog breaks it down to seven steps and demonstrate how to build the Hacker news clone from start to finish.

## Step 1: Basic Project set up

We will need to set up the basic project directory and `npm` package manager. It has the following steps:

  - create a project directory
    mkdir hacker_news_clone_guide
  - create an empty `index.html`
  - create `src` folder
  - create an empty `src/main.js`
  - create `static` folder
  - upload logo to `static/logo.png`

`src/main.js` is going to be the entry Javascript file of the entire project. `src/` directory contains application code. `static/` directory contains static assets such as images.

Now we need to initiate `npm` by running `npm init` within the package, after the command we should see `package.json` existed in the directory. Inside `package.json`, we manages external Javascript package dependencies.

We will install *webpack* by running 

    npm install webpack -g

Then we use *webpack* to point *main.js* to *webpack.config.js*
  
    webpack ./src/main.js webpack.config.js

This is the end of step 1, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/7b53a22190d65a82623214753a4bb52bf3a64a38)

## Step 2: create index.html and App.vue

Modify `index.html` to be the following:

{% gist f7aa1614c1714be29e68bd2e36997179 index_1.html %}

Notice that “<div id=“app”></div>” is the main identifier of the Vue app. To build the app, we will use both `Vue` and `Vue-router`. We load the dependency and initiate the `Vue` router within `main.js` like the following:

{% gist f7aa1614c1714be29e68bd2e36997179 main_1.js %}

First, we will create an `App` component that contains other components. It has the following steps:

  - create directory “src/components"
  - create file “src/components/App.vue"
  - create file “src/variables.styl” for asset styling
  - add “App.vue” to “main.js” and modify the routing

After the steps above, we will compile the project by running `webpack`, it should compile successfully and we should see the following screen:

![vue_step_2](/images/vue_step_2.png)

This is the end of step 2, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/c50316bf494365677b09ea172e53e6571019a860)

## Step 3: connect HackerNews API

We need to use [Hacker News API](https://github.com/HackerNews/API) to fetch real data, and we need to use the following APIs:

| Sample URL             | Data                                                                                     |
|------------------------|------------------------------------------------------------------------------------------|
| /v0/topstories.json    | returns a list of item IDs                                                               |
| /v0/item/12430298.json | returns a specific item with ID, an item can be a comment, an ask, a poll in Hacker News |
| /v0/user/jl.json       | returns information for a specific user                                                  |

We will also later handle *pagination* by combining the results of three APIs we are using. To build the API client, we isolate the calls within `store` directory and file `store/index.js`. We have the following steps:

  - create `store` folder
  - create “store/index.js” its only responsibility is to make API calls to Hacker News

This is the end of step 3, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/bd70d7b2cf3bf40383c54b0958b7dfd3dcb84377)

## Step 4: register Vue filter

We will build the feature to show when an item is posted on Hacker News, and the domain in which the source comes from. [Vue custom filter](https://vuejs.org/guide/custom-filter.html) is a great tool for that. It has the following steps:

  - create directory "src/filter"
  - create file "src/filter/index.js", and we will register the filter functions within `index.js`
  - register *Vue filters* within `main.js`

This is the end of step 4, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/4bd87730486cd182c9c41b751a2caeb97d7d6fee)

## Step 5: create components for news board and each news

Now we're ready to create the main page of Hacker News! On the main page, we will have the a big frame that includes each piece of news. We will separate them into "News" component and "Item" component. It has the following steps:

  - create "src/components/NewsView.vue"
  - create "src/components/Item.vue", and `NewsView.vue` includes `Item.vue`
  - Register  com in `src/main.js`
  - Add routes to `NewsView.vue`
  - default the entry route to `NewsView.vue`

After finish the steps above, run `webpack` and it should compile successfully and we should the following screen:

![vue_step_5](/images/vue_step_5.png)

This is the end of step 5, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/ccacadedaef459080bb248864f089ba6543eb2b7)

## Step 6: create component for users

On each item of the HackerNews page, we should be able to click into a user and see her detailed information. So we can add another component for `UserView`. The component should also have its own route as well. It has the following steps:

  - create file “components/UserView.vue"
  - register the new route in “main.js"

Compile using “webpack”, it should compile successfully, when you click into a user, then you should see something like this:

![vue_step_6](/images/vue_step_6.png)

This is the end of step 6, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/25b9f1d0f506899b5aa814f22b97e48a9f130189)

## Step 7: create component for comments and polls

The last piece is the comment section. When we click on comments link we should see a detailed page of comment exchange. Filters and User information should also apply in the comment, so we can reuse some of the components we already built. It has the following steps:

  - create file “components/Comment.vue”, the component is already linked within “Item.vue".
  - create file “components/ItemView.vue”.
  - register the new route in `main.js`.

Compile using “webpack”, it should compile successfully, when you click into comments into a story, then you should see something like this:

![vue_step_7](/images/vue_step_7.png)

This is the end of step 7, you can see the commit [here](https://github.com/marshallshen/vue-hackernews-guide/commit/6f42b73ce3c74b7de86b1a60140f06766e2180a1)

## Conclusion

That's it! We build the HackerNews clone using 7 steps. The blogpost is based on [Vue.js HackerNews Clone](https://github.com/vuejs/vue-hackernews) and I also pushed the [guide repo](https://github.com/marshallshen/vue-hackernews-guide) for the tutorial. You can find each step organized in separate commits [here](https://github.com/marshallshen/vue-hackernews-guide/commits/master).

When I started learning `Vue.js` I wanted to follow a step-by-step guide to build a `Vue.js` app, and this blogpost is a tutorial I wish had existed. Please leave your comment on how I can improve this tutorial so people can find it helpful for them! Thanks for reading!


