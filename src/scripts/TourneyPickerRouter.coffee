define([
  'backbone',
  'TourneyPickerModel',
  'TourneyPickerView'
], (Backbone, TourneyPickerModel, TourneyPickerView) ->

	class TourneyPickerRouter extends Backbone.Router

		routes:
			'': '_overviewPage'
			'admin': '_adminPage'

		initialize: ->
			@model = new TourneyPickerModel()
			view = new TourneyPickerView(
				model: @model
			)
			Backbone.history.start()

		_overviewPage: =>
			

		_adminPage: =>
			

)
