define([
  'jquery',
  'backbone',
  'templates',
  'datepicker'
], ($, Backbone, Templates, datepicker) ->

	class BrowseTournamentsView extends Backbone.View

		events:
			'click #new-tournament': '_newTournament'

		initialize: ->
			@model.on('change:tournaments', @_render)
			@model.on('change:user', @_render)
			@model.getTournaments()

		_render: =>
			tournaments = @model.get('tournaments')
			user = @model.get('user')
			@$el.html Handlebars.templates['BrowseTournaments']({tournaments: tournaments, canCreateTournament: user?.access > 1})

		_newTournament: =>
			window.document.location.href = '#createTournament'

)
