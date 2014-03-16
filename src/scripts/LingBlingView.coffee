define([
  'backbone',
  'templates',
  'bootstrap'
], (Backbone, Templates, bootstrap) ->

	class LingBlingView extends Backbone.View

		initialize: ->
			@model.on('change:page', @_updatePage)
			@model.on('change:user', @_updateUser)

			$('body').html Handlebars.templates['MainView']()

			@signInButton = $('#sign-in-button')
			@signOutButton = $('#sign-out-button')
			@profileDropdownContainer = $('#profile-dropdown-container')
			@profileDropdown = $('#profile-dropdown')
			@profileLink = $('#profile-link')

			@signInButton.click(@_signIn)
			@signOutButton.click(@_signOut)

			@_updateUser()

		_signIn: =>
			@model.signIn()

		_signOut: =>
			@model.signOut()

		_updatePage: =>
			page = @model.get('page')
			
			# update the header links if necessary
			$('.nav').children('li').each ->
				$(@).removeClass('active')
			if page.getLabel?
				$('#' + page.getLabel() + '-link').addClass('active')

			page.show()

		_updateUser: =>
			user = @model.get('user')

			if user?
				@signInButton.hide()
				@profileDropdown.text(user.handle)
				@profileLink.attr('href', '#profile/' + user.id)
				@profileDropdownContainer.show()
			else
				@profileDropdownContainer.hide()
				@signInButton.show()

)
