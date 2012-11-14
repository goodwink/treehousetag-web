'use strict'

### Directives ###

putObject = (path, object, value) ->
  modelPath = path.split(".")
 
  fill = (object, elements, depth, value) ->
    hasNext = ((depth + 1) < elements.length)
    
    if depth < elements.length && hasNext
      if !object.hasOwnProperty(modelPath[depth])
        object[modelPath[depth]] = {}

      fill(object[modelPath[depth]], elements, ++depth, value)
    else
      object[modelPath[depth]] = value

  fill(object, modelPath, 0, value)

pushObject = (path, object, value) ->
  modelPath = path.split(".")
 
  fill = (object, elements, depth, value) ->
    hasNext = ((depth + 1) < elements.length)
    
    if depth < elements.length && hasNext
      if !object.hasOwnProperty(modelPath[depth])
        object[modelPath[depth]] = {}

      fill(object[modelPath[depth]], elements, ++depth, value)
    else
      if !object[modelPath[depth]]?
        object[modelPath[depth]] = []

      object[modelPath[depth]].push(value)

  fill(object, modelPath, 0, value)

angular.module('app.directives', [
  'app.services'
])

.directive('appVersion', [
  'version'

(version) ->

  (scope, elm, attrs) ->
    elm.text(version)
])

.directive('datepicker', ->
  (scope, element, attrs) ->
    element.datepicker
      changeMonth: true
      changeYear: true
      onSelect: (dateText) ->
        modelPath = $(this).attr('ng-model')

        putObject(modelPath, scope, dateText)
        scope.$apply()
)

.directive('masonry', ->
  (scope, element, attrs) ->
    if scope.$last
      container = element.parent()

      container.imagesLoaded ->
        container.masonry
          itemSelector: '.block'
          columnWidth: 20
)

.directive('onEnter', ->
  (scope, element, attrs) ->
    element.keyup (event) ->
      if event.which == 13
        event.preventDefault()
        scope.$apply(attrs.onEnter)
)