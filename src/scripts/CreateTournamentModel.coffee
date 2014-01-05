define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class CreateTournamentModel extends Backbone.Model

		initialize: ->

		getGames: =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/games'
				success: (data) =>
					@set('games', data)
				error: (e) =>
					console.log e

		getPlayers: (game) =>
			$.ajax
				type: 'GET'
				url: 'http://lingbling.net/players/' + encodeURIComponent(game)
				success: (data) =>
					@set('players', data)
				error: (e) =>
					console.log e

		createTournament: (name, game, rounds) =>
			tournament = {
				name: name,
				game: game,
				rounds: rounds
			}

			$.ajax
				type: 'POST'
				url: 'http://lingbling.net/tournaments'
				data: tournament
				success: (data) =>
				error: (e) =>
					console.log e

		createPlayer: (handle, game) =>
			player = { handle: handle, game: game }

			$.ajax
				type: 'POST'
				url: 'http://lingbling.net/players'
				async: false
				data: player
				success: (data) =>
				error: (e) =>
					console.log e
			@getPlayers(player.game)

)
