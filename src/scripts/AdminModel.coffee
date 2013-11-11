define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class AdminModel extends Backbone.Model

		initialize: ->
			
		getTourneys: =>
			$.ajax
				type: 'GET'
				url: 'http://localhost:3000/tourneys'
				async: false
				success: (data) =>
					@set('tourneys', data)
				error: (e) =>
					console.log e

)