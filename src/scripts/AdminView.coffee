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
			'change .round-format': '_refreshPlayerSelector'

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
			@model.on('change:tourneys', @_updateTourneysList)
			@model.getTourneys()

		_updateTourneysList: =>
			@$el.html Handlebars.templates['Admin'](@model.get('tourneys'))

		_newTournament: =>
			@model.getGames()
			games = @model.get('games')
			gameNames = []
			for game in games
				gameNames.push game.name
			@$el.html Handlebars.templates['CreateTournament'](gameNames)
			@model.getPlayers()
			players = @model.get('players')
			@playerHandles = []
			for player in players
				@playerHandles.push player.handle
			@numRounds = 0

		_createTournament: =>
			tournament = {
				game: $('#game').val(),
				name: $('#name').val(),
				rounds: [
				]
			}
			for round in $('#rounds').find('.round')
				dateParts = $(round).find('.round-duedate').val().split('/')
				dueDate = new Date(dateParts[2], dateParts[0] - 1, dateParts[1]).toJSON()
				roundFormat = $(round).find('.round-format').val()
				groups = []
				# {
				# 	groups: [
				# 		{
				# 			players: [ "Leenock", "MVP", "Nestea", "Fruitdealer" ],
				# 			winners: [ "Leenock", "Nestea" ]
				# 		},
				# 		{
				# 			players: [ "Jaedong", "MaruPrime", "Rain", "Innovation" ],
				# 			winners: []
				# 		}
				# 	]
				# }
				tournament.rounds.push { dueDate: dueDate, format: roundFormat, groups: groups }
			console.log tournament

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
