define([
  'jquery',
  'backbone',
  'templates',
  'datepicker'
], ($, Backbone, Templates, datepicker) ->

	class TournamentView extends Backbone.View

		initialize: ->
			@model.on('change:tournament', @_render)
			Handlebars.registerPartial("Tournament", Handlebars.templates["Tournament"])
			@model.getTournament()

		_render: =>
			tournament = @model.get('tournament')
			console.log tournament
			@$el.html Handlebars.templates['Tournament'](tournament)

)
