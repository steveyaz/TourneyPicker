define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class OverviewModel extends Backbone.Model

		initialize: ->

		getTourneys: =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/tourneys'
				async: false
				success: (data) =>
					@set('tourneys', data)
				error: (e) =>
					console.log e

)
