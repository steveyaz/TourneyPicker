define([
	'jquery',
	'backbone',
	'LingBlingPage',
	'BrowseTournamentsModel',
	'BrowseTournamentsView',
	'CreateTournamentModel',
	'CreateTournamentView',
	'OverviewModel',
	'OverviewView',
	'ProfileModel',
	'ProfileView',
	'TournamentModel',
	'TournamentView',
	'GoogleAuth'
], ($, Backbone, LingBlingPage, BrowseTournamentsModel, BrowseTournamentsView, CreateTournamentModel, CreateTournamentView, OverviewModel, OverviewView, ProfileModel, ProfileView, TournamentModel, TournamentView, GoogleAuth) ->

	class LingBlingModel extends Backbone.Model

		initialize: ->
			# Create the pages
			@pages = {}

			# Overview page
			@pages.overview = new LingBlingPage(@,
				getUrl: -> ''
				getTitle: -> 'LingBling'
				createModel: -> @model = new OverviewModel()
				createView: -> @view = new OverviewView(model: @model)
			)

			# Browse Tournaments page
			@pages.tournaments = new LingBlingPage(@,
				getUrl: -> 'tournaments'
				getTitle: -> 'LingBling Tournaments'
				getLabel: -> 'tournaments'
				createModel: -> @model = new BrowseTournamentsModel()
				createView: -> @view = new BrowseTournamentsView(model: @model)
			)

			# Create Tournament page
			@pages.createTournament = new LingBlingPage(@,
				getUrl: -> 'createTournament'
				getTitle: -> 'LingBling Create Tournament'
				createModel: -> @model = new CreateTournamentModel()
				createView: -> @view = new CreateTournamentView(model: @model)
			)

			# View Tournament page
			@pages.tournament = new LingBlingPage(@,
				getUrl: -> 'tournament'
				getTitle: -> 'Tournament'
				setId: (id) -> @model.setId(id)
				createModel: -> @model = new TournamentModel()
				createView: -> @view = new TournamentView(model: @model)
			)

			# View Profile page
			@pages.profile = new LingBlingPage(@,
				getUrl: -> 'profile'
				getTitle: -> 'User Profile'
				setId: (id) -> @model.setId(id)
				createModel: -> @model = new ProfileModel()
				createView: -> @view = new ProfileView(model: @model)
			)

			# Google auth
			@googleAuth = new GoogleAuth()
			@googleAuth.onSignIn = @onGoogleSignIn

			# Check the session to see if already signed in
			@checkSession()

		setPage: (page) =>
			currentPage = @get('page')
			samePage = currentPage is page
			currentPage?.destroy()
			@set('page', page)
			# Backbone doesn't trigger a change event if the reference hasn't changed
			if samePage
				@trigger('change:page')

		signIn: =>
			@googleAuth.checkAuth(false)

		checkSession: =>
			$.ajax
				type: 'POST'
				url: 'https://lingbling.net/checksession'
				async: false
				success: (data) =>
					if data.status is 'signedin'
						console.log 'Signed in successfully'
						@set('user', data.user)
					else if data.status is not 'signedout'
						@googleAuth.checkAuth(true)
				error: (e) ->
					console.log e

		onGoogleSignIn: (auth) =>
			$.ajax
				type: 'POST'
				url: 'https://lingbling.net/signin'
				async: false
				data:
					accessToken: auth['access_token']
				success: (data) =>
					console.log 'Signed in successfully'
					@set('user', data)
				error: (e) ->
					console.log e

		signOut: =>
			@set('user', null)
			$.ajax
				type: 'POST'
				url: 'https://lingbling.net/signout'
				async: false
				success: (data) ->
					console.log 'Signed out successfully'
				error: (e) ->
					console.log e

)
