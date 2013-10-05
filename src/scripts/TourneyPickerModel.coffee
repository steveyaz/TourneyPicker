define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class TourneyPickerModel extends Backbone.Model

		initialize: ->
			

		onLogin: (auth) =>
			$.ajax
				type: 'POST'
				url: 'http://localhost:3000/login'
				async: false
				data:
					accessToken: auth.get('accessToken')
				success: (data) ->
					console.log data
				error: (e) ->
					console.log e
					# You could point users to manually disconnect if unsuccessful
					# https://plus.google.com/apps

		onLogout: =>


)
