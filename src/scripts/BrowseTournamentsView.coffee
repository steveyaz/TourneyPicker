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
			@model.getTournaments()

		_render: =>
			tournaments = @model.get('tournaments')
			@$el.html Handlebars.templates['BrowseTournaments'](tournaments)

		_newTournament: =>
			window.document.location.href = '#createTournament'

)
