# How To Build a Cool Email Form with AngularJS, Node.js, Windows Azure, and SendGrid

[AngularJS](http://www.angularjs.org) is a hot, open source JavaScript MVC framework for creating web apps ranging 
in complexity from simple to highly sophisticated. This article shows how to build a simple, yet powerful, email 
contact form that has some cool bells and whistles.

In it, you'll see some of the core capabilities that make AngularJS so powerful and easy to use, like:

* Easily creating a single-page application and Twitter Bootstrap support
* Two-way data-binding
* Expressions
* Repeaters
* Built-in Directives
* Custom Directives
* Services
* Dependency-injection
* RESTful communication

It also uses Node.js on Windows Azure in conjunction with the SendGrid mail service to easily send emails 
and attach files.

# Example form: sign up to help kids learn how to code

The company I work for, VersionOne, is sponsoring a new CoderDojo in Atlanta. TODO: complete

# Simple way to structure a single-page application (SPA), styled with Twitter Bootstrap

Twitter Bootstrap is a very popular HTML framework of CSS styles and widgets that make your sites look great with
minimal coding and customization. The AngularJS team at Google created an extension library to the core of AngularJS
that makes it easy to use Twitter Bootstrap in your UI.

Here's how we structure the shell for our SPA and make it use Twitter Bootstrap:

```html
<!doctype html>
<html lang='en'>
<head>
  <meta charset='utf-8'>
  <title>CoderDojo Ponce Springs Mentor Sign Up</title>
  <link href='//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.min.css' rel='stylesheet' />
  <link href='css/signup.css' rel='stylesheet' />
</head>
<body ng-app='mentorSignUp'>
  <div ng-view></div>
  <script src='//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js '></script>
  <script src='//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.js'></script>
  <script src='//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular-resource.js'></script>
  <script src='//angular-ui.github.io/bootstrap/ui-bootstrap-tpls-0.3.0.js'></script>
  <script src='js/mongoLab.js'></script>  
  <script src='js/app.js'></script>
</body>
</html>
```

Notes:


# Two-way databinding for HTML form fields makes many DOM manipulation cases a thing of the past


```html
<div class="control-group">
  <label class="control-label required" for="email">Email</label>
  <div class="controls">
    <input ng-model="form.email" class="input-xlarge" required type="text">
    <p class="help-block">user@example.com</p>
  </div>
</div>
```
Notice that the `input` tag does not have an `id` attribute, but does have an `ng-model` attribute set to 
`form.email`.

Over on the `Preview` tab, we also have this:

```html
<h4>Email</h4>
<div class='field'>{{form.email}}</div>
```

The cool thing about this is that as soon as you start typing into the `input` tag in the `Form` tab, the 
value gets reflected into the `div` on the `Preview` tab! AngularJS's two-way databinding takes care of this 
automatically for you.

# Expressions let your HTML view access variables and functions defined by your controller in a `$scope` or `$rootScope`

TODO

# Repeaters are instantiated by the `ng-repeat` directive as an attribute on the HTML element you want to repeat for 
each item in an array or object

TODO

# Directives are how Angular extends HTML with custom attributes and elements

TODO

# Create a custom directive for validating that the email and email confirm field match, and invalidate the form if not

TODO

# Make a custom service for communicating with MongoLab via its REST API

TODO



