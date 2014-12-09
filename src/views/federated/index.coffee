Backbone = require 'backbone'
$ = require 'jquery'

tpl = require './index.jade'

###
@class
@extends Backbone.View
###
class Federated extends Backbone.View

	className: 'federated'

	###
	@constructs
	###
	initialize: (@options) ->
		@render()

	render: ->
		@$el.append tpl()

		@

	events: ->
		'click button': '_handleFederatedLogin'

	_handleFederatedLogin: (ev) ->
		@options.user.federatedLogin()

	destroy: ->
		@remove()

module.exports = Federated