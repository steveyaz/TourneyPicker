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

		getGames: =>
			$.ajax
				type: 'GET'
				url: 'http://localhost:3000/games'
				async: false
				success: (data) =>
					@set('games', data)
				error: (e) =>
					console.log e

		getPlayers: =>
			$.ajax
				type: 'GET'
				url: 'http://localhost:3000/players'
				async: false
				success: (data) =>
					@set('players', data)
				error: (e) =>
					console.log e

		addTournament: (tournament) =>
			$.ajax
				type: 'POST'
				url: 'http://localhost:3000/tourneys'
				async: false
				data: tournament
				success: (data) =>
					@set('players', data)
				error: (e) =>
					console.log e
			@getTourneys()


)
