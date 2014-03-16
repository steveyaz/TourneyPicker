define([
  'backbone',
  'LingBlingModel',
  'LingBlingView'
], (Backbone, LingBlingModel, LingBlingView) ->

	class LingBlingRouter extends Backbone.Router

		routes:
			'': '_overviewPage'
			'tournaments': '_tournamentsPage'
			'createTournament': '_createTournamentPage'
			'profile/:id': '_profilePage'
			'tournament/:id': '_tournamentPage'

		initialize: ->
			@model = new LingBlingModel()
			view = new LingBlingView(
				model: @model
			)
			@model.on('change:page', @_setPage)
			Backbone.history.start()

		_setPage: =>
			page = @model.get('page')
			window.document.title = page.getTitle()

		_overviewPage: =>
			@model.setPage(@model.pages.overview)

		_tournamentsPage: =>
			@model.setPage(@model.pages.tournaments)

		_createTournamentPage: =>
			@model.setPage(@model.pages.createTournament)

		_profilePage: (id) =>
			@model.setPage(@model.pages.profile)
			@model.pages.profile.setId(id)

		_tournamentPage: (id) =>
			@model.setPage(@model.pages.tournament)
			@model.pages.tournament.setId(id)

)
