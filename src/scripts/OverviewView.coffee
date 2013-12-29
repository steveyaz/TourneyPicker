define([
  'jquery',
  'backbone',
  'templates'
], ($, Backbone, Templates) ->

	class OverviewView extends Backbone.View

		initialize: ->
			Handlebars.registerPartial("FeaturedTournament", Handlebars.templates["FeaturedTournament"])
			@model.getTourneys()
			@_showOverview()

		_showOverview: =>
			console.log @model.get('tourneys')
			@$el.html Handlebars.templates['Overview'](@model.get('tourneys'))
)
