define([
  'jquery',
  'backbone',
  'templates'
], ($, Backbone, Templates) ->

	class OverviewView extends Backbone.View

		initialize: ->
			@model.on('change:tournaments', @_render)
			Handlebars.registerPartial("FeaturedTournament", Handlebars.templates["FeaturedTournament"])
			@model.getTournaments()

		_render: =>
			tournaments = @model.get('tournaments')
			@$el.html Handlebars.templates['Overview'](tournaments)
)
