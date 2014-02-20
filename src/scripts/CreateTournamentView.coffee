define([
  'jquery',
  'backbone',
  'templates',
  'datepicker'
], ($, Backbone, Templates, datepicker) ->

	class CreateTournamentView extends Backbone.View

		events:
			'click #create-tournament': '_createTournament'
			'click #cancel-create-tournament': '_navigateToBrowseTournaments'
			'click #add-round': '_addRound'
			'click #remove-round': '_removeRound'
			'click #create-new-player': '_createNewPlayer'
			'change .round-format': '_layoutFirstRound'
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

			@model.on('change:players', @_updatePlayers)
			@model.on('change:games', @_render)
			@model.on('change:user', @_render)
			@numRounds = 0
			@model.getGames()

		_render: =>
			@$el.html null
			if not @model.get('user')? or @model.get('user').access < 2
			 	return

			# first selection option should be 'select game'
			games = @model.get('games')
			games.splice(0, 0, { id: 'default', name: 'select game' })

			@$el.html Handlebars.templates['CreateTournament'](games)

		_gameSelectionChanged: =>
			@selectedGame = $('#game').val()
			$('#game option[value="default"]').remove()
			# update the player selection dropdowns
			@model.getPlayers(@selectedGame)

		_createNewPlayer: =>
			# a game needs to be selected
			if not @selectedGame?
				return
			playerHandle = $('#new-player-handle').val()
			# ensure the player handle was entered
			if not not playerHandle and playerHandle not in players
				@model.createPlayer(playerHandle, @selectedGame)
			# clear the create player form
			$('#new-player-handle').val('')

		_updatePlayers: =>
			players = @model.get('players')
			@playerHandles = []
			for player in players
				@playerHandles.push player.handle
			@firstRoundFormat = ''
			@_layoutFirstRound()

		_layoutFirstRound: =>
			# the first round is the only round you set the players for
			firstRoundFormat = $($('#rounds').children().children('.round')[@numRounds - 1]).find('.round-format').val()
			if @firstRoundFormat is firstRoundFormat
				return
			@firstRoundFormat = firstRoundFormat
			# layout the first round and populate its dropdowns with the players
			playersDiv = $('#players')
			playersDiv.empty()
			if @firstRoundFormat is 'bracket'
				for i in [1..Math.pow(2, (@numRounds - 1))]
					playersDiv.append(Handlebars.templates['Bracket'](@playerHandles))
			else if @firstRoundFormat is 'group4' and @numRounds > 1
				for i in [1..Math.pow(2, (@numRounds - 2))]
					playersDiv.append(Handlebars.templates['Group4'](@playerHandles))

		_addRound: =>
			if @numRounds < 6
				$('#rounds').append(Handlebars.templates['CreateTournamentRound'](@roundNames[@numRounds]))
				$('.round-datepicker:last').datepicker()
				@numRounds++
				@firstRoundFormat = ''
				@_layoutFirstRound()

		_removeRound: =>
			if @numRounds > 0
				$('#rounds').children().children()[@numRounds].remove()
				@numRounds--
				@firstRoundFormat = ''
				@_layoutFirstRound()

		_createTournament: =>
			rounds = {}
			roundNumber = 1
			for round in $('#rounds').find('.round')
				dateParts = $(round).find('.round-startDate').val().split('/')
				startDate = new Date(dateParts[2], dateParts[0] - 1, dateParts[1]).toJSON()
				roundFormat = $(round).find('.round-format').val()
				groups = []
				for group in $('#players').children()
					currentGroup = {}
					currentGroup.players = []
					for player in $(group).children()
						currentGroup.players.push $(player).val()
					groups.push currentGroup
				rounds[roundNumber] = { startDate: startDate, format: roundFormat, groups: groups }
				roundNumber++
			@model.createTournament($('#name').val(), @selectedGame, rounds)
			@_navigateToBrowseTournaments()

		_navigateToBrowseTournaments: =>
			window.document.location.href = '#tournaments'

)
