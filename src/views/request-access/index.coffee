Backbone = require 'backbone'
$ = require 'jquery'

funcky = require 'funcky.req'

tpl = require './index.jade'
###
@class
###
class RequestAccess extends Backbone.View

	className: 'request-access inactive'

	###
	@constructs
	###
	initialize: (@settings) ->
		@render()

	render: ->
		@$el.append tpl()

		@

	events: ->
		'click h3': '_handleClick'
		'click button': "_handleSubmit"

	_handleClick: (ev) ->
		@$el.removeClass 'inactive'
		@trigger 'request-access'

	_handleSubmit: (ev) ->
		ev.preventDefault()

		form = @el.querySelector('form')

		data = JSON.stringify
			"full-name": form.elements["full-name"].value
			"email": form.elements["email"].value

		req = funcky.post @settings.requestAccessUrl,
			data: data

		req.done =>
			@_handleRequestSend()

		req.fail =>
			console.log 'fail!'

	_handleRequestSend: ->
		@$('form').hide()
		@$('.message').show()

		setTimeout (=>
			@trigger "request-send"
		), 2000

	destroy: ->
		@remove()

module.exports = RequestAccess