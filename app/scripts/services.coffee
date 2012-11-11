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

  ($http, $cookieStore, $location, $timeout, User) ->
    currentUser: null

    login: (email, password, success, error) ->
      $http.post('/api/sessions',
        email: email,
        password: password
      ).success((data, status) ->
        if status == 200
          $http.defaults.headers.common['X-Auth-Token'] = data.token
          $cookieStore.put('userId', data.id)
          $cookieStore.put('userToken', data.token)
          @currentUser = User.get({id: data.id})
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
            (->),
            (->
              $location.path('/')
            )
          )
        else
          $location.path('/')

    user: ->
      @currentUser
])

.factory('User', [
  '$resource'

  ($resource) ->
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
