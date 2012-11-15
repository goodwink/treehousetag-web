'use strict'

# Declare app level module which depends on filters, and services
App = angular.module('app', [
  'ngCookies'
  'ngResource'
  'ui'
  'app.controllers'
  'app.directives'
  'app.filters'
  'app.services'
])

App.config([
  '$routeProvider'
  '$locationProvider'

($routeProvider, $locationProvider, config) ->

  $routeProvider

    .when '/',
      templateUrl: '/partials/landing.html'
      controller: 'LandingCtrl'
    .when '/children',
      templateUrl: '/partials/children.html'
      controller: 'ChildrenCtrl'
    .when '/interests',
      templateUrl: '/partials/interests.html'
      controller: 'InterestsCtrl'
    .when '/home',
      templateUrl: '/partials/home.html'
      controller: 'HomeCtrl'
    .when '/friends',
      templateUrl: '/partials/friends.html'
      controller: 'FriendsCtrl'
    .when '/calendar',
      templateUrl: '/partials/calendar.html'
      controller: 'CalendarCtrl'

    # Catch all
    .otherwise({redirectTo: '/'})

  # Without server side support html5 must be disabled.
  $locationProvider.html5Mode(false)
])
