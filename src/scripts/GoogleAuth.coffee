define([
], ->

	class GoogleAuth

		constructor: ->
			window.googleAuthClientLoad = @_onClientLoad
			@clientId = '722928241069'
			@apiKey = 'AIzaSyAz_3B_LfTAAHlLLRzSWwnyHU_TgCr75ZQ'
			@scope = 'https://www.googleapis.com/auth/userinfo.email'

			# asynchronous load of gapi
			po = document.createElement('script')
			po.type = 'text/javascript'
			po.async = true
			po.src = 'https://apis.google.com/js/client.js?onload=googleAuthClientLoad'
			s = document.getElementsByTagName('script')[0]
			s.parentNode.insertBefore(po, s)

		checkAuth: (immediate) =>
			gapi.auth.authorize({client_id: @clientId, scope: @scope, immediate: immediate}, @_onAuthResultReturned)

		_onClientLoad: =>
			gapi.client.setApiKey(@apiKey)
			window.setTimeout(@checkAuth(true), 1)

		_onAuthResultReturned: (authResult) =>
			if authResult['access_token']?
				console.log('Google authentication successful')
				@onSignIn(authResult)
			else if authResult['error']
				console.log('There was an error with Google authentication: ' + authResult['error'])

)
