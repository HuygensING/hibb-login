Backbone = require 'backbone'

tpl = require './index.jade'

# TODO Put POST (hahaha) request in model?

###
@class
@extends Backbone.View
###
class Basic extends Backbone.View

	className: 'local'

	###
	@constructs
	###
	initialize: (@options) ->
		@render()

	render: ->
		@$el.append tpl()

		@

	events: ->
		'click button': '_handleLogin'
		'keyup input[type="password"]': '_handlePasswordInputKeyup'

	_handlePasswordInputKeyup: (ev) ->
		if ev.keyCode is 13
			@_handleLogin()

	_handleLogin: (ev) ->
		ev.preventDefault() if ev?

		return if @$el.hasClass 'has-error'

		user = @$('input[type="text"]').val()
		pass = @$('input[type="password"]').val()

		if user.length is 0 or pass.length is 0
			return @_showError "Username or password is empty."

		@options.user.basicLogin user, pass
		@listenTo @options.user, 'basic:unauthorized', (res) =>
			message = JSON.parse(res.response).message

			if res.status is 401
				@_showError message

	_showError: (msg) ->
		@$('button').html(msg)
		@$el.addClass 'has-error'

		setTimeout (=>
			@$('button').html('Login')
			@$el.removeClass 'has-error'
		), 4000

	destroy: ->
		@remove()

module.exports = Basic