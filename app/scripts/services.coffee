'use strict'

### Sevices ###

angular.module('app.services', ['ngResource'])

.factory('version', -> '0.1')

.factory('Session', [
  '$http'

  ($http) ->
    login: (email, password, success, error) ->
      $http.post('/api/sessions',
        email: email,
        password: password
      ).success((data, status) ->
        if status == 200
          $http.defaults.headers.common['X-Auth-Token'] = data.token
          success?(data.id)
        else
          error?(data, status)
      ).error((data, status) ->
        error?(data, status)
      )

    logout: (success) ->
      $http.delete "/api/sessions/#{$http.defaults.headers.common['X-Auth-Token']}"
      delete $http.defaults.headers.common['X-Auth-Token']
      
      success?()
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
