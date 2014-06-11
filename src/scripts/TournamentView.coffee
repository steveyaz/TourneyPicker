define([
  'jquery',
  'backbone',
  'templates',
  'datepicker'
], ($, Backbone, Templates, datepicker) ->

	class TournamentView extends Backbone.View

		initialize: ->
			@model.on('change:tournament', @_render)
			@model.getTournament()

		_render: =>
			tournament = @model.get('tournament')
			@$el.html Handlebars.templates['Tournament'](tournament)

)
