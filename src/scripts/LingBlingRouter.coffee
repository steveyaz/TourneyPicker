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
			@navigate(page.getUrl())

		_overviewPage: =>
			@model.setPage(@model.pages.overview)

		_tournamentsPage: =>
			@model.setPage(@model.pages.tournaments)

		_createTournamentPage: =>
			@model.setPage(@model.pages.createTournament)

)