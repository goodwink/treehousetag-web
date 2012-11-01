'use strict'

### Controllers ###

angular.module('app.controllers', [])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'

($scope, $location, $resource, $rootScope) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  $scope.signup =
    children: [{}]

  # getClass compares the current url with the id.
  # If the current url starts with the id it returns 'active'
  # otherwise it will return '' an empty string. E.g.
  #
  #   # current url = '/products/1'
  #   getClass('/products') # returns 'active'
  #   getClass('/orders') # returns ''
  #
  $scope.getClass = (id) ->
    if $scope.activeNavId.substring(0, id.length) == id
      return 'active'
    else
      return ''

  $scope.loggedIn = ->
    false
])

.controller('LandingCtrl', [
  '$scope'

($scope) ->
  handlePosition = (position) ->
    $scope.signup.position = position.coords

  $scope.locateMe = ->
    navigator?.geolocation?.getCurrentPosition?(handlePosition)
])

.controller('ChildrenCtrl', [
  '$scope'

($scope) ->
  $scope.genderClasses = (child, gender) ->
    classes = ['small', 'radius', 'button', gender]

    if child.gender == gender
      classes.push('active')

    classes

])

.controller('InterestsCtrl', [
  '$scope'

($scope) ->
  $scope.tagConfig =
    tags: [
      "baseball"
      "basketball"
      "basket-making"
      "cheesey-puffs"
    ]

  $scope.createAccount = ->
    console.log $scope.signup

])

.controller('HomeCtrl', [
  '$scope'

($scope) ->
  $scope.activitySuggestions =
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

])
