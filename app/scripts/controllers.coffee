'use strict'

### Controllers ###

angular.module('app.controllers', [])

.controller('AppCtrl', [
  '$scope'
  '$location'
  '$resource'
  '$rootScope'
  'Session'
  'User'

($scope, $location, $resource, $rootScope, Session, User) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  $scope.signup =
    user: {}
    children: [{}]

  $scope.user = null

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
    $scope.user?

  $scope.logIn = ->
    Session.login $scope.login.email, $scope.login.password, (id) ->
      $scope.dropdownOpen = false
      $scope.user = User.get({id: id})
      $location.path('/home')
      # FIXME: handle this error
])

.controller('LandingCtrl', [
  '$scope'

($scope) ->
  handlePosition = (position) ->
    $scope.signup.user.latitude = position.coords.latitude
    $scope.signup.user.longitude = position.coords.longitude
    $scope.locationSaved = true
    $scope.$digest()

  $scope.locateMe = ->
    navigator?.geolocation?.getCurrentPosition?(handlePosition)
])

.controller('ChildrenCtrl', [
  '$scope'
  '$location'

($scope, $location) ->
  unless $scope.signup.user.email
    $location.path('/')

  $scope.genderClasses = (child, gender) ->
    classes = ['small', 'radius', 'button', gender]

    if child.gender == gender
      classes.push('active')

    classes

])

.controller('InterestsCtrl', [
  '$scope'
  '$location'
  'User'
  'Session'
  'Child'
  'Interest'

($scope, $location, User, Session, Child, Interest) ->
  unless $scope.signup.user.email
    $location.path('/')

  $scope.interests = Interest.query()

  $scope.createAccount = ->

    created = ->
      Session.login(
        $scope.user.email,
        $scope.signup.user.password,
        (->
          $scope.user.children = []

          for child in $scope.signup.children
            $scope.user.children.push(c = new Child(child))
            c.$save()),
        failed)

    failed = ->
      # FIXME: Do something to handle this condition

    $scope.user = new User($scope.signup.user)
    $scope.user.$save(undefined, created, failed)
])

.controller('HomeCtrl', [
  '$scope'
  '$location'

($scope, $location) ->
  unless $scope.loggedIn()
    $location.path('/')

  $scope.activitySuggestions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

])
