define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class OverviewModel extends Backbone.Model

		initialize: ->

		getTournaments: =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/tournaments'
				success: (data) =>
					@set('tournaments', data)
				error: (e) =>
					console.log e

)
