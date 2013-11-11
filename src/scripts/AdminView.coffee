define([
  'jquery',
  'backbone',
  'templates'
], ($, Backbone, Templates) ->

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
			@$el.html Handlebars.templates['CreateTournament'](@model.get('tourneys'))
			@numRounds = 0

		_createTournament: =>


		_addRound: =>
			if @numRounds < 6
				$('#rounds').append(Handlebars.templates['CreateTournamentRound'](@roundNames[@numRounds]))
				@numRounds++

		_removeRound: =>
			if @numRounds > 0
				$('#rounds').children().children()[@numRounds].remove()
				@numRounds--

)
