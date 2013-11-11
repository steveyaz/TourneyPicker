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
			@model.on('change:page', @_setPage)
			Backbone.history.start()

		_overviewPage: =>
			@model.setPage(@model.pages.overview)

		_adminPage: =>
			@model.setPage(@model.pages.admin)

		_setPage: =>
			page = @model.get('page')
			window.document.title = page.getTitle()
			@navigate(page.getUrl())

)
