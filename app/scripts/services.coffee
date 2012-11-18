'use strict'

### Sevices ###

angular.module('app.services', ['ngResource', 'ngCookies'])

.factory('version', -> '0.1')

.factory('Session', [
  '$http'
  '$cookieStore'
  '$location'
  '$timeout'
  'User'
  'Child'

  ($http, $cookieStore, $location, $timeout, User, Child) ->
    currentUser: null

    login: (email, password, success, error) ->
      $http.post('/api/sessions',
        email: email,
        password: password
      ).success((data, status) =>
        if status == 200
          $http.defaults.headers.common['X-Auth-Token'] = data.token
          $cookieStore.put('userId', data.id)
          $cookieStore.put('userToken', data.token)
          @currentUser = User.get {id: data.id}, =>
            @currentChildren =
              @currentUser.children.map (childId) ->
                Child.get({id: childId})
          success?()
        else
          error?(data, status)
      ).error((data, status) ->
        error?(data, status)
      )

    logout: (success) ->
      $http.delete "/api/sessions/#{$http.defaults.headers.common['X-Auth-Token']}"
      delete $http.defaults.headers.common['X-Auth-Token']
      
      success?()

    checkOrRedirect: () ->
      unless @currentUser?
        if ((cookieUserId = $cookieStore.get('userId')) &&
            (cookieToken = $cookieStore.get('userToken')))
          $http.defaults.headers.common['X-Auth-Token'] = cookieToken

          @currentUser = User.get(
            {id: cookieUserId},
            (=>
              @currentChildren = @currentUser.children.map (childId) ->
                Child.get({id: childId})
            ),
            (->
              $location.path('/')
            )
          )
        else
          $location.path('/')

    user: ->
      @currentUser

    children: ->
      @currentChildren
])

.factory('User', [
  '$resource'

  User = ($resource) ->
    $resource '/api/users/:id',
      id: '@id'
])

.factory('Child', [
  '$resource'

  ($resource) ->
    $resource '/api/children/:id',
      id: '@id'
])

.factory('Interest', [
  '$resource'

  ($resource) ->
    $resource '/api/interests/:id',
      id: '@id'
])

.factory('Recommendation', [
  '$resource'

  ($resource) ->
    $resource '/api/recommendations/:id',
      id: '@id'
])

.factory('Friend', [
  '$resource'

  ($resource) ->
    $resource '/api/friends/:id',
      id: '@id'
])

.factory('UserFriend', [
  '$resource'

  ($resource) ->
    $resource '/api/users/:userId/friends/:friendId', {userId: '@userId', friendId: '@friendId'},
      addFriend: {method: 'PUT'}
])

.factory('Event', [
  '$resource'

  ($resource) ->
    $resource '/api/events/:id', {id: '@id'},
      rsvp: {method: 'PUT', isArray: true}
])
