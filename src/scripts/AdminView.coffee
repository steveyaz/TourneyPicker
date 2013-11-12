define([
  'jquery',
  'backbone',
  'templates',
  'datepicker'
], ($, Backbone, Templates, datepicker) ->

	class AdminView extends Backbone.View

		events:
			'click .new-tournament': '_newTournament'
			'click .create-tournament': '_createTournament'
			'click #add-round': '_addRound'
			'click #remove-round': '_removeRound'

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
			@numRounds = 0

		_createTournament: =>


		_addRound: =>
			if @numRounds < 6
				$('#rounds').append(Handlebars.templates['CreateTournamentRound'](@roundNames[@numRounds]))
				$('.round-datepicker:last').datepicker()
				@numRounds++

		_removeRound: =>
			if @numRounds > 0
				$('#rounds').children().children()[@numRounds].remove()
				@numRounds--

)
