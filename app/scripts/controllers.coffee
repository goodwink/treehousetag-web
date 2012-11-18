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
  '$timeout'

($scope, $location, $resource, $rootScope, Session, User, $timeout) ->

  # Uses the url to determine if the selected
  # menu item should have the class active.
  $scope.$location = $location
  $scope.$watch('$location.path()', (path) ->
    $scope.activeNavId = path || '/'
  )

  $scope.Session = Session
  $scope.$watch('Session.user()', (user) ->
    $scope.user = user
  )
  $scope.$watch('Session.children()', (children) ->
    $scope.children = children
  )

  $scope.signup =
    user: {}
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
    Session.user()?

  $scope.logIn = ->
    Session.login $scope.login.email, $scope.login.password, ->
      $scope.dropdownOpen = false
      $scope.user = Session.user()
      $location.path('/home')
      # FIXME: handle this error

  $scope.gravatar = (email) ->
    if email?
      hash = md5(email.trim().toLowerCase())
      "http://www.gravatar.com/avatar/#{hash}?d=monsterid"

  $scope.gravatarSmall = (email) ->
    if email?
      $scope.gravatar(email) + "&s=24"
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
  'Session'
  'Recommendation'

($scope, Session, Recommendation, Child) ->
  Session.checkOrRedirect()

  $scope.placeSuggestions = Recommendation.query()

  $scope.styleForSuggestion = (suggestion) ->
    if suggestion?.place?.image?
      {"background-image": "url('#{suggestion.place.image}')"}
    else
      {}

])

.controller('FriendsCtrl', [
  '$scope'
  'Session'
  'Friend'
  'UserFriend'
  'User'

($scope, Session, Friend, UserFriend, User) ->
  Session.checkOrRedirect()

  $scope.newFriends = [{}]

  $scope.friends = Friend.query()

  $scope.friendSuggestions = Friend.query({suggested: true})

  $scope.addFriendRequest = (friend) ->
    Friend.save friend, (invitation) ->
      if invitation.status == 'sent'
        friend.statusText = "Sent!"
      else
        friend.statusText = "Complete!"
        friend.statusIcon = ["icon-ok", "status-icon"]

        $scope.friends.push(invitation)

    friend.statusIcon = ["icon-share", "status-icon"]
    friend.statusText = "Sending"

    $scope.newFriends.push({})

  $scope.addFriendSuggestion = (suggestion) ->
    UserFriend.addFriend {userId: $scope.user.id, friendId: suggestion.id}, () ->
      $scope.friends.push(User.get({id: suggestion.id}))
      $scope.friendSuggestions = $scope.friendSuggestions.filter (s) ->
        s != suggestion

])

.controller('CalendarCtrl', [
  '$scope'
  'Session'
  'Event'

($scope, Session, Event) ->
  Session.checkOrRedirect()

  $scope.monthFormatted = moment().format("MMMM YYYY")

  $scope.month = (i for i in [1..moment().daysInMonth()])

  $scope.dayWidth = (day) ->
    if day < 10
      {width: "#{20 / 9}%"}
    else
      {width: "#{80 / ($scope.month.length - 9)}%"}

  $scope.schedules = Event.query({accepted: true})

  $scope.invitations = Event.query()

  $scope.rsvp = (invitation, rsvp) ->
    Event.rsvp {id: invitation.event.id, rsvp: rsvp}, (results) ->
      results.forEach (result) ->
        $scope.schedules.push(result) if rsvp
        $scope.invitations = $scope.invitations.filter (i) ->
          i != invitation

  $scope.dayFormatted = (schedule) ->
    moment(schedule.event.time).date()

  $scope.dateFormatted = (schedule) ->
    moment(schedule.event.time).format("M/d")

  $scope.timeFormatted = (schedule) ->
    moment(schedule.event.time).format("h:mm a")

  $scope.dayClass = (day) ->
    classes = ['day']

    if day < moment().date()
      classes.push('past')
    else
      classes.push('future')

    busy = $scope.schedules.some (schedule) ->
      date = moment(schedule.event.time)

      date.date() == day && date.month() == moment().month

    if busy then classes.push('busy')

    classes
])
