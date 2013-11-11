define([
	'jquery',
	'backbone',
	'TourneyPickerPage',
	'AdminModel',
	'AdminView'
], ($, Backbone, TourneyPickerPage, AdminModel, AdminView) ->

	class TourneyPickerModel extends Backbone.Model

		initialize: ->
			# Create the pages
			@pages = {}

			# Create the Admin page
			@pages.admin = new TourneyPickerPage(
				getUrl: -> 'admin'
				getTitle: -> 'Tourney Picker Admin'
				createModel: -> @model = new AdminModel()
				createView: -> @view = new AdminView(model: @model)
				updateView: -> @model.trigger('updateData')
			)

		setPage: (page) =>
			currentPage = @get('page')
			samePage = currentPage is page
			currentPage?.destroy()
			@set('page', page)
			# Backbone doesn't trigger a change event if the reference hasn't changed
			if samePage
				@trigger('change:page')

			

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

		onLogout: (auth) =>
			$.ajax
				type: 'POST'
				url: 'http://localhost:3000/logout'
				async: false
				data:
					accessToken: auth.get('accessToken')
				success: (data) ->
					console.log data
				error: (e) ->
					console.log e
					# You could point users to manually disconnect if unsuccessful
					# https://plus.google.com/apps

)
