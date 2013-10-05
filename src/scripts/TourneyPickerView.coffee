define([
  'backbone',
  'templates',
  'GoogleAuth'
], (Backbone, Templates, GoogleAuth) ->

	class TourneyPickerView extends Backbone.View

		initialize: ->
			$('body').html Handlebars.templates['GoogleSignin']({
				signinCallback: 'googleSigninCallback',
				appId: '722928241069'
			})
			googleAuth = new GoogleAuth()
			googleAuth.on('change:accessToken', @model.onLogin)
			window.googleSigninCallback = googleAuth.signinCallback

)
