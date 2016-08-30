---
layout:     post
title:      Responsive Web with Rails and Vuejs
date:       2016-08-29
categories: blog
tags: ["Rails", "Vuejs", "Javascript"]
blog: true
---

## Introduction

Rails is a great web framework and Vue.js is a powerful and minimal Javascript framework. In this tutorial, we will learn how to effectively use Rails and Vue.js together.

we will build a clone site of Airbnb called Vuebnb. The website renders place listings based on which room type you select. Below are the code and demo site for this tutorial:

1. [Demo](https://vuebnb.herokuapp.com/)
2. [Source Code](https://github.com/marshallshen/vuebnb)

Below is the snapshot of what the one page looks like:

![vuebnb](/images/vuebnb.jpg)


The tutorial has two parts, the first part is building Rails backend with one HTML/HAML page. The second part is integrating that one frontend page with *Vue.js*.

## Rails Backend

For the simple page page, we have two models involved: *place* and *host*. A *host* can have many *places*. Generate *place* model using a Rails command

	rails g model Place city:string price:integer place_type:string host_id:integer image_url:string

Generate *host* model using another Rails command

	rails g model Host name:string profile_url:string

We should have models as following:

{% gist 023237734cc6864a9fd56a898c66a4b8 host.rb %}
{% gist 023237734cc6864a9fd56a898c66a4b8 place.rb %}

Now we will build out API endpoints for fetching places and hosts. This will later be used by AJAX callback on our page. Following the practice of Test Driven Development, we will first defined our test case, we will use Rspec 3 as our app testing framework.  We will use `ActiveModel::Serializer` to standardize our JSON payload. We will use the standard JSON payload and reflect it in our test cases.

Let's add `Serializer` into our Gemfile

	gem 'active_model_serializers', '~> 0.10.0'

First we will write tests on the API we will build, in this blog post, we will first focus on building *places* endpoint, so let's start with *places_spec*.

{% gist 023237734cc6864a9fd56a898c66a4b8 places_spec.rb %}

Additionally, we can add tests for *hosts* endpoint as well.

{% gist 023237734cc6864a9fd56a898c66a4b8 hosts_spec.rb %}

Let's add routes, controllers and serializers to make tests pass

Add `routes`
{% gist 023237734cc6864a9fd56a898c66a4b8 routes.rb %}

Add `controllers` to places and hosts
{% gist 023237734cc6864a9fd56a898c66a4b8 places_controller.rb %}
{% gist 023237734cc6864a9fd56a898c66a4b8 hosts_controller.rb %}

Add `serializers` for places and hosts
{% gist 023237734cc6864a9fd56a898c66a4b8 place_serializer.rb %}
{% gist 023237734cc6864a9fd56a898c66a4b8 host_serializer.rb %}

If you run `rspec spec`, the tests should pass. We will add seed data to prepare for frontend development.

## Vuejs Frontend

Let's add `vuejs` into the app. We're using `vuejs-rails`

	gem 'vuejs-rails'

And we add `vuejs` into our Javascript dependency, we will also create a `vuebnb.js` file and load it in our dependency tree too.

{% gist 023237734cc6864a9fd56a898c66a4b8 application.js %}

*Vuejs* use *el* to bind DOM elements. Rather than using *div id* or other CSS class, we will use *data attributes* as the selector of our element.

{% gist 023237734cc6864a9fd56a898c66a4b8 show-1.html.haml %}

I try to avoid using *div id* for code readability and I like that CSS is only used for decoration. Because we have *{data: {show_listing: true}}*, now we can fetch the element using *[data-show-listing]*. Let's initialize our *Vue.js* object.

{% gist 023237734cc6864a9fd56a898c66a4b8 vuebnb-1.js %}

After we initialize the *Vue.js* object, let's create our ajax call to fetch all the places.

{% gist 023237734cc6864a9fd56a898c66a4b8 vuebnb-2.js %}

Now we want to build the toggle feature: when different place type is selected, the result should change. We will use *computed property* to render the real time change.

{% gist 023237734cc6864a9fd56a898c66a4b8 vuebnb-2.js %}

On the HTML page, we use *filteredPlaces* to render the page.

{% gist 023237734cc6864a9fd56a898c66a4b8 show-2.html.haml %}

## Conclusion

There are many features we can build further. Feel free to fork the repo and try it! Over the years, *Rails* community has developed some really neat concept for API servers. I also like how easy it is to hook *Vue.js* into frontend.










