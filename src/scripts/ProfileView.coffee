define([
  'jquery',
  'backbone',
  'templates'
], ($, Backbone, Templates) ->

	class ProfileView extends Backbone.View

		events:
			'click #edit-handle': '_editHandle'
			'click #save-handle': '_saveHandle'

		initialize: ->
			@model.on('change:profile', @_render)
			Handlebars.registerPartial("Profile", Handlebars.templates["Profile"])
			Handlebars.registerPartial("TournamentList", Handlebars.templates["TournamentList"])
			@model.getProfile()
			@isEditing = false

		_render: =>
			profile = @model.get('profile')
			@$el.html Handlebars.templates['Profile'](profile)
			@handle = $('#handle')
			@editableHandle = $('#editable-handle')
			@editButton = $('#edit-handle')
			@saveButton = $('#save-handle')
			@profileDropdown = $('#profile-dropdown')
			@editableHandle.hide()
			@saveButton.hide()

		_editHandle: =>
			@editableHandle.val(@handle.text())
			@isEditing = not @isEditing
			if @isEditing
				@handle.hide()
				@editableHandle.show()
				@saveButton.show()
				@editButton.text('cancel')
			else
				@saveButton.hide()
				@editableHandle.hide()
				@handle.show()
				@editButton.text('edit')

		_saveHandle: =>
			oldHandle = @handle.text()
			newHandle = @editableHandle.val()
			if newHandle? and not (newHandle  == '') and not (oldHandle == newHandle)
				@handle.text(newHandle)
				@model.updateHandle(newHandle)
				@profileDropdown.text(newHandle)
			@_editHandle()

)
