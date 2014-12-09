$ = require 'jquery'

Login = require './views/login'
User = require './models/user'

assert = require 'assert'

class Main

	constructor: ->
		@initialized = false

		@_views =
			login: null

		@_user = null

	###
	@method
	@param {object} this.settings - Initialize the LoginComponent with settings.
	@param {boolean} [this.settings.basic=false]
	@param {boolean} [this.settings.federated=false]
	###
	init: (@settings={}) ->
		assert.ok @settings.federated or @settings.basic, "HIBB Login: There must either be a federated or a basic login! Set federated or basic to true with the LoginComponent's init method."

		@initialzed = true

	getLoginView: (options={}) ->
		assert.ok @initialized, "HIBB Login: Initialize with settings first: see http://nu.nl"

		options.user = @getUser()

		if @_views.login?
			@_views.login.destroy()

		@_views.login = new Login @settings, options

	getUser: ->
		unless @_user?
			throw new Error "HIBB Login: you have to create the user before you can get it!"

		@_user

	###
	@param {object} options
	@param {string} tokenPrefix
	@param {function} url
	@param {object} headers
	###
	createUser: (options={}) ->
		@_user = new User [], @settings, options

		# Don't return the new user. The user can only be retrieved by invoking @getUser.
		null

module.exports = new Main()