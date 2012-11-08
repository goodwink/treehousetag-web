'use strict'

describe "service", ->

  beforeEach(module "app.services")

  describe "Session", ->

    it "login should cause all future requests to include X-Auth-Token header", inject ($httpBackend, Session, $http) ->
        expect(Session.login).not.toBeUndefined()

        $httpBackend.expectPOST('/api/sessions').respond
          token: 'bogustoken'

        Session.login
          email: 'foo@bar.com'
          password: 'bogus'

        $httpBackend.flush()

        $httpBackend.expectGET('/api/bogus', (headers) ->
          headers['X-Auth-Token'] == 'bogustoken'
        ).respond(foo: true)

        $http.get('/api/bogus')

        $httpBackend.flush()

    it "logout should cause all future requests to cease including X-Auth-Token header", inject ($httpBackend, Session, $http) ->
        expect(Session.login).not.toBeUndefined()

        $httpBackend.expectPOST('/api/sessions').respond
          token: 'bogustoken'

        Session.login
          email: 'foo@bar.com'
          password: 'bogus'

        $httpBackend.flush()

        $httpBackend.expectGET('/api/bogus', (headers) ->
          headers['X-Auth-Token'] == 'bogustoken'
        ).respond(foo: true)

        $http.get('/api/bogus')

        $httpBackend.flush()

        $httpBackend.expectDELETE('/api/sessions/bogustoken').respond({})

        Session.logout()

        $httpBackend.expectGET('/api/bogus', (headers) ->
          !headers['X-Auth-Token']?
        ).respond(foo: true)

        $http.get('/api/bogus')

        $httpBackend.flush()
