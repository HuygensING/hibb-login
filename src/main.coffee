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
	# @method
	# @param {Object} this.settings - Initialize the LoginComponent with settings.
	# @param {Object} [this.settings.federated]
	# @param {String} [this.settings.federated.url]
	# @param {Object} [this.settings.basic]
	# @param {String} [this.settings.basic.url]
	# @param {String} [this.settings.requestAccessUrl]
	###
	init: (@settings={}) ->
		assert.ok @settings.federated? or @settings.basic?, "HIBB Login: There must either be a federated or a basic login! Set federated or basic to true with the LoginComponent's init method: see https://github.com/HuygensING/hibb-login#init%C3%ACalize."

		@initialized = true

	getLoginView: (options={}) ->
		assert.ok @initialized, "HIBB Login: Initialize with settings first: see https://github.com/HuygensING/hibb-login#init%C3%ACalize"

		options.user = @getUser()

		@destroyLoginView()

		@_views.login = new Login @settings, options

	destroyLoginView: ->
		if @_views.login?
			@_views.login.destroy()

	getUser: ->
		unless @_user?
			throw new Error "HIBB Login: you have to create the user before you can get it!"

		@_user

	###
	@param {Object} options
	@param {String} tokenPrefix
	@param {String} tokenType="" - The type of token. Is used as a prefix when sending the Authorization header.
	@param {Function} url
	@param {Object} headers
	###
	createUser: (options={}) ->
		options.tokenType ?= ""

		@_user = new User [], @settings, options

		# Don't return the new user. The user can only be retrieved by invoking @getUser.
		null

module.exports = new Main()