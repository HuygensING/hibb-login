# Huygens ING Backbone Login

View, model and logic for logging in.

## Initìalize

```coffeescript
LoginComponent = require 'hibb-login'

LoginComponent.init
	basic:
		url: "http://some-url-for-basic-authentication"
	federated:
		url: "http://some-url-for-federated-authentication"

LoginComponent.createUser
	tokenPrefix: "some-prefix"
	url: -> "http://some-url-to-get-user-data"
	headers:
		KEY: "value"
```

## Other methods

```coffeescript
# Get the user.
LoginComponent.getUser()

# Get the token.
LoginComponent.getUser().getToken()

# Get the login view.
LoginComponent.getLoginView
	title: "Login"
	modal: true
```

## Changelog