define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class ProfileModel extends Backbone.Model

		initialize: ->

		setId: (id) =>
			@id = id
			@getProfile()

		getProfile: =>
			if (@id?)
				$.ajax
					type: 'GET'
					url: 'https://lingbling.net/profile/' + @id
					success: (data) =>
						@set('profile', data)
					error: (e) =>
						console.log e

		updateHandle: (newHandle) =>
			$.ajax
				type: 'PUT'
				url: 'https://lingbling.net/profile/' + newHandle
				success: (data) =>
				error: (e) =>
					console.log e

		updateUser: (lingblingmodel) =>
			@set('user', lingblingmodel.get('user'))

)
