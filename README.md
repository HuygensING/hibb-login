# Huygens ING Backbone Login

View, model and logic for logging in.

## Initialize

```coffeescript
# Require the module.
LoginComponent = require 'hibb-login'

# Init the component with the type of logins you need.
LoginComponent.init
	basic:
		url: "http://some-url-for-basic-authentication"
	federated:
		url: "http://some-url-for-federated-authentication"

# Create the user.
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

### v1.2.0
* :sparkles: Add button to request access to federated login