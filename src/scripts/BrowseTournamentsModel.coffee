define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class BrowseTournamentsModel extends Backbone.Model

		initialize: ->

		getTournaments: =>
			@_getTournaments()
			@_getGames()

		updateUser: (lingblingmodel) =>
			@set('user', lingblingmodel.get('user'))
			
		_getTournaments: =>
			$.ajax
				type: 'GET'
				url: 'https://lingbling.net/tournaments'
				success: (data) =>
					@tournaments = data
					if @tournaments? and @games
						@_joinTournamentsWithGames()
				error: (e) =>
					console.log e

		_getGames: =>
			$.ajax
				type: 'GET'
				url: 'https://lingbling.net/games'
				success: (data) =>
					@games = data
					if @tournaments? and @games
						@_joinTournamentsWithGames()
				error: (e) =>
					console.log e

		_joinTournamentsWithGames: =>
			# index the games by id in order to join on tournaments
			gamesObj = {}
			for game in @games
				gamesObj[game.id] = game
			# replace the game id with the actual game object
			for tournament in @tournaments
				tournament.game = gamesObj[tournament.game]

			@set('tournaments', @tournaments)

)
