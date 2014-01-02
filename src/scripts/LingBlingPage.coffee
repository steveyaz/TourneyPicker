define([
	'jquery',
	'backbone',
	'BrowseTournamentsModel',
	'BrowseTournamentsView',
	'CreateTournamentModel',
	'CreateTournamentView'
], ($, Backbone) ->

	class LingBlingPage
		
		constructor: (stuff) ->
			_.extend(@, stuff)

		show: =>
			if not @model?
				@createModel()
			if not @view?
				@createView()
				$('#content').append @view?.$el

		render: =>
			@updateView()

		destroy: =>
			@view?.remove()
			@view?.off()
			@view = null
			@model = null
)