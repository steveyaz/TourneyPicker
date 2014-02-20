define([
	'jquery',
	'backbone',
	'BrowseTournamentsModel',
	'BrowseTournamentsView',
	'CreateTournamentModel',
	'CreateTournamentView'
], ($, Backbone) ->

	class LingBlingPage
		
		constructor: (lingblingmodel, stuff) ->
			@lingblingmodel = lingblingmodel
			_.extend(@, stuff)

		show: =>
			if not @model?
				@createModel()
				@lingblingmodel.on('change:user', @model.updateUser)
				@model.updateUser(@lingblingmodel)
			if not @view?
				@createView()
				$('#content').append @view?.$el

		destroy: =>
			@view?.remove()
			@view?.off()
			@view = null
			@model = null

)