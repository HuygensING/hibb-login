# User = require './user'

# class FederatedUser extends User
	
# 	###
# 	@override
# 	###
# 	isLoggedIn: ->
# 		@_handleTokenInUrl()

# 		@getToken()?

# 	_handleTokenInUrl: ->
# 		path = window.location.search.substr 1
# 		parameters = path.split '&'

# 		for param in parameters
# 			[key, value] = param.split('=')

# 			if key is 'hsid'
# 				@setToken value
# 				history.replaceState? {}, '', window.location.pathname

# 	# initialize: -> super
# 	# isLoggedIn: -> super
# 	# getToken: -> super
# 	# setToken: -> super

# module.exports = FederatedUser