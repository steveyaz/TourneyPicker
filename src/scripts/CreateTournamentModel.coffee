define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class CreateTournamentModel extends Backbone.Model

		initialize: ->
			
		getTournaments: =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/tournaments'
				async: false
				success: (data) =>
					@set('tournaments', data)
				error: (e) =>
					console.log e

		getGames: =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/games'
				async: false
				success: (data) =>
					@set('games', data)
				error: (e) =>
					console.log e

		getPlayers: (game) =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/players/' + encodeURIComponent(game)
				async: false
				success: (data) =>
					@set('players', data)
				error: (e) =>
					console.log e

		addTournament: (tournament) =>
			$.ajax
				type: 'POST'
				url: 'http://lingbling.net/tournaments'
				async: false
				data: tournament
				success: (data) =>
					console.log data
				error: (e) =>
					console.log e
			@getTournaments()

		addPlayer: (player) =>
			$.ajax
				type: 'POST'
				url: 'http://lingbling.net/players'
				async: false
				data: player
				success: (data) =>
					console.log data
				error: (e) =>
					console.log e
			@getPlayers(player.game)

)
