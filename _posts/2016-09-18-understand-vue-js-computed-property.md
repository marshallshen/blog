---
layout:     post
title:      Understand Vue.js Computed Property
date:       2016-09-18
categories: blog
tags: ["Vue.js", "Javascript"]
blog: true
---

Computed Properties are data that is composed using other data; it helps organize logic using Vue.js data attributes. One use case is to build “selectAll” checkboxes. Imagine making checkboxes to select types of amenities for a summer trip. Several features are specified for “selectAll” checkbox.

![vue_checkbox](/images/vue_checkbox.png)

*Select all amenities*. When “selectAll” checkbox is selected, all the checkboxes will be selected.

*Select individual amenity*. When an individual checkbox is selected, only that checkbox is selected, and nothing else.

*Unselect all amenities*. If  “selectAll” is unchecked, all the checkboxes will be unchecked, regardless of the state of each checkbox.

*Unselect individual amenity*. When an individual checkbox is unchecked, that checkbox is unchecked, and also “selectAll” checkbox is unchecked.

The basic boolean value is set on individual options under Vue data:

    data: {
         options: [
          { id: 1, text: 'Airline Ticket', checked: false },
          { id: 2, text: 'Hotel', checked: false },
          { id: 3, text: 'Car', checked: false}
         ]
    }


On top of basic boolean values, a computed property “allSelected” is built based on the states of all items. If the boolean value “checked” on each option is set “true,” then “allSelected” returns true. Otherwise “allSelected” return false. The attribute “selectedAll” depends on data and logic, and it’s a perfect use case for Vue.js computed property.

    computed: {
      allSelected: function(){
        for (var i = 0; i < this.options.length; i++){
          if (this.options[i].checked == false) {
            return false;
          }
        }
        
        return true;
      }
    },

On each option, we register an action that can toggle the “checked” value on each item.
  
    methods: {
       toggleOption: function(option){
        var checked = option.checked
        option.checked = !checked;
      }
    }

On “selectAll”, we register an action that can toggle the “checked” value across all items. Because “selectAll” resets all options, the scope of toggled value needs to be outside of the for loop.

    toggleAll: function(){
      var checked = this.allSelected;
      for (var i = 0; i < this.options.length; i++){  
        this.options[i].checked = !checked;
      }
    },

The complete script of this feature is below:

<iframe width="100%" height="300" src="//jsfiddle.net/mshen1226/d49go70f/7/embedded/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

Computed Property is a popular concept existing in many modern JS frameworks such as Vue.js and Ember.js. It’s a powerful tool to simplify and organize logic units in the application.