Backbone = require 'backbone'
$ = require 'jquery'
_ = require 'underscore'

funcky = require 'funcky.req'

btoa = require 'btoa'

###
EVENTS TRIGGERED

basic:authorized
basic:unauthorized
unauthorized
data-fetched
###

class User extends Backbone.Model

	initialize: (attrs, @settings, @options) ->
		@url = @options.url() if @options.url?
		@fetched = false
		@_prefix = "hi-#{@options.tokenPrefix}"

		@tokenPropertyName = "#{@_prefix}-auth-token"
		
	_checkTokenInUrl: ->
		path = window.location.search.substr 1
		parameters = path.split '&'

		for param in parameters
			[key, value] = param.split('=')

			if key is 'hsid'
				@setToken value
				Backbone.history.navigate window.location.pathname, trigger: true

	_fetchUserData: ->
		options = 
			success: =>
				@trigger 'data-fetched'
				@fetched = true
			error: (m, response, opts) =>
				if response.status is 401
					@removeToken()
					@trigger 'unauthorized', response

			headers:
				Authorization: @getToken()

		_.extend options.headers, @options.headers

		@fetch options

	basicLogin: (username, password) ->
		options =
			headers:
				Authorization: 'Basic ' + btoa(username+':'+password)

		req = funcky.post @settings.basic.url, options
		req.done (res) =>
			token = res.getResponseHeader('X_AUTH_TOKEN')
			@trigger 'basic:authorized', token
			@setToken token
			@_fetchUserData()

		req.fail (res) =>
			if res.hasOwnProperty('response')
				response = JSON.parse(res.response)
			@trigger 'basic:unauthorized', res

	federatedLogin: ->
		wl = window.location;
		hsURL = wl.origin + wl.pathname
		loginURL = @settings.federated.url

		form = $ '<form>'
		form.attr
			method: 'POST'
			action: loginURL

		hsUrlEl = $('<input>').attr
			name: 'hsurl'
			value: hsURL
			type: 'hidden'

		form.append hsUrlEl
		$('body').append form

		form.submit()

	authorize: ->
		@_checkTokenInUrl() if @settings.federated
		@_fetchUserData() unless @fetched

		@

	isLoggedIn: ->
		@getToken()?

	removeToken: ->
		localStorage.removeItem @tokenPropertyName

	setToken: (token) ->
		localStorage.setItem @tokenPropertyName, @options.tokenType + token

	getToken: ->
		localStorage.getItem @tokenPropertyName

	setFederatedLoginStarted: ->
		localStorage.setItem "#{@_prefix}-federated-login-started", true

	federatedLoginHasStarted: ->
		localStorage.getItem("#{@_prefix}-federated-login-started")?



module.exports = User