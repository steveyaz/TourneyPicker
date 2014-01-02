define([
	'jquery',
	'backbone',
	'LingBlingPage',
	'BrowseTournamentsModel',
	'BrowseTournamentsView',
	'CreateTournamentModel',
	'CreateTournamentView',
	'OverviewModel',
	'OverviewView'
], ($, Backbone, LingBlingPage, BrowseTournamentsModel, BrowseTournamentsView, CreateTournamentModel, CreateTournamentView, OverviewModel, OverviewView) ->

	class LingBlingModel extends Backbone.Model

		initialize: ->
			# Create the pages
			@pages = {}

			# Overview page
			@pages.overview = new LingBlingPage(
				getUrl: -> ''
				getTitle: -> 'LingBling'
				createModel: -> @model = new OverviewModel()
				createView: -> @view = new OverviewView(model: @model)
				updateView: -> @model.trigger('updateData')
			)

			# Browse Tournaments page
			@pages.tournaments = new LingBlingPage(
				getUrl: -> 'tournaments'
				getTitle: -> 'LingBling Tournaments'
				getLabel: -> 'tournaments'
				createModel: -> @model = new BrowseTournamentsModel()
				createView: -> @view = new BrowseTournamentsView(model: @model)
				updateView: -> @model.trigger('updateData')
			)

			# Create Tournament page
			@pages.createTournament = new LingBlingPage(
				getUrl: -> 'createTournament'
				getTitle: -> 'LingBling Create Tournament'
				createModel: -> @model = new CreateTournamentModel()
				createView: -> @view = new CreateTournamentView(model: @model)
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
				url: 'http://lingbling.net/login'
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
				url: 'http://lingbling.net/logout'
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
