define([
  'jquery',
  'backbone',
  'templates',
  'datepicker'
], ($, Backbone, Templates, datepicker) ->

	class AdminView extends Backbone.View

		events:
			'click #new-tournament': '_newTournament'
			'click #create-tournament': '_createTournament'
			'click #add-round': '_addRound'
			'click #remove-round': '_removeRound'
			'click #create-new-player': '_createNewPlayer'
			'change .round-format': '_refreshPlayerSelector'
			'change #game': '_gameSelectionChanged'

		initialize: ->
			@roundNames = [
				'Finals',
				'Semi-Finals',
				'Quarter-Finals',
				'Round of 16',
				'Round of 32',
				'Round of 64'
			]

			Handlebars.registerPartial("CreateTournamentRound", Handlebars.templates["CreateTournamentRound"])
			@model.on('change:players', @_updatePlayers)
			@model.getTourneys()
			@_showAdminHome()

		_showAdminHome: =>
			@$el.html Handlebars.templates['Admin'](@model.get('tourneys'))

		_newTournament: =>
			@model.getGames()
			games = @model.get('games')
			gameNames = []
			gameNames.push 'select game'
			for game in games
				gameNames.push game.name
			@$el.html Handlebars.templates['CreateTournament'](gameNames)
			@numRounds = 0

		_createTournament: =>
			tournament = {
				game: @selectedGame,
				name: $('#name').val(),
				rounds: [
				]
			}
			for round in $('#rounds').find('.round')
				dateParts = $(round).find('.round-duedate').val().split('/')
				dueDate = new Date(dateParts[2], dateParts[0] - 1, dateParts[1]).toJSON()
				roundFormat = $(round).find('.round-format').val()
				groups = []
				for group in $('#players').children()
					currentGroup = {}
					currentGroup.players = []
					currentGroup.winners = []
					for player in $(group).children()
						currentGroup.players.push $(player).val()
					groups.push currentGroup
				tournament.rounds.push { dueDate: dueDate, format: roundFormat, groups: groups }
			@model.addTournament(tournament)
			@_showAdminHome()

		_gameSelectionChanged: =>
			@selectedGame = $('#game').val()
			$('#game option[value="select game"]').remove()
			@model.getPlayers(@selectedGame)

		_createNewPlayer: =>
			if not @selectedGame?
				return
			playerHandle = $('#new-player-handle').val()
			if not not playerHandle and playerHandle not in players
				player = { handle: playerHandle, game: @selectedGame }
				@model.addPlayer(player)
			$('#new-player-handle').val('')

		_updatePlayers: =>
			players = @model.get('players')
			@playerHandles = []
			for player in players
				@playerHandles.push player.handle
			@firstRoundFormat = ''
			@_refreshPlayerSelector()

		_addRound: =>
			if @numRounds < 6
				$('#rounds').append(Handlebars.templates['CreateTournamentRound'](@roundNames[@numRounds]))
				$('.round-datepicker:last').datepicker()
				@numRounds++
				@firstRoundFormat = ''
				@_refreshPlayerSelector()

		_removeRound: =>
			if @numRounds > 0
				$('#rounds').children().children()[@numRounds].remove()
				@numRounds--
				@firstRoundFormat = ''
				@_refreshPlayerSelector()

		_refreshPlayerSelector: =>
			firstRoundFormat = $($('#rounds').children().children('.round')[@numRounds - 1]).find('.round-format').val()
			if @firstRoundFormat is firstRoundFormat
				return
			@firstRoundFormat = firstRoundFormat

			playersDiv = $('#players')
			playersDiv.empty()
			if @firstRoundFormat is 'bracket'
				for i in [1..Math.pow(2, (@numRounds - 1))]
					playersDiv.append(Handlebars.templates['Bracket'](@playerHandles))
			else if @firstRoundFormat is 'group4' and @numRounds > 1
				for i in [1..Math.pow(2, (@numRounds - 2))]
					playersDiv.append(Handlebars.templates['Group4'](@playerHandles))

)
