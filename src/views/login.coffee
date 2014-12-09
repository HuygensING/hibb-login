Backbone = require 'backbone'
$ = require 'jquery'

Modal = require 'hibb-modal'

Federated = require './federated'
Basic = require './basic'

###
@class
@extends Backbone.View
###
class Login extends Backbone.View

	id: 'hibb-login'

	###
	@constructs
	
	@param {object} this.settings
	@param {object} this.settings.boolean
	@param {string} this.settings.boolean.url
	@param {object} this.settings.federated
	@param {string} this.settings.federated.url

	@param {object} this.options
	@param {object} this.options.user
	@param {function} this.options.success - Callback after succesful login.
	@param {boolean} [this.options.modal=false] - Render login form in a modal.
	###
	initialize: (@settings, @options) ->
		@options.modal ?= false

		@listenTo @options.user, 'basic:authorized', @_handleBasicSuccess

		@render()

	render: ->
		if @settings.federated?
			federated = new Federated(user: @options.user)

			@$el.append federated.el

		if @settings.basic?
			basic = new Basic(user: @options.user)
			@$el.append basic.el



		if @options.modal
			@_modal = new Modal
				html: @el
				cancelAndSubmit: false
				title: @options.title
				width: '400px'

			@listenTo @_modal, 'cancel', => @trigger 'modal:cancel'
			@listenTo @_modal, 'close', => @trigger 'modal:close'

		@

	destroy: ->
		@_modal.destroy() if @options.modal

		@remove()

	_handleBasicSuccess: (token) =>
		if @options.modal
			@_modal.messageAndFade 'success', "Access granted!"

			@listenToOnce @_modal, 'close', =>
				@options.success() if @options.success?
		else
			@options.success() if @options.success?

module.exports = Login