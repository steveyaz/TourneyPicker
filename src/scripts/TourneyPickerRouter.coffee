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
			console.log 'TourneyPickerRouter'
			@model = new TourneyPickerModel()
			view = new TourneyPickerView() {model: @model}
			Backbone.history.start()

		_overviewPage: =>
			console.log 'OverviewPage'

		_adminPage: =>
			console.log 'Admin'

)
