define([
	'jquery',
	'backbone'
], ($, Backbone) ->

	class TournamentModel extends Backbone.Model

		initialize: ->

		setId: (id) =>
			@id = id
			@getTournament()

		getTournament: =>
			if (@id?)
				$.ajax
					type: 'GET'
					url: 'https://lingbling.net/tournaments/' + @id
					success: (data) =>
						console.log data
						@set('tournament', data)
					error: (e) =>
						console.log e

		updateUser: (lingblingmodel) =>
			@set('user', lingblingmodel.get('user'))

)
