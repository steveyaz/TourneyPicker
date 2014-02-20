define([
  'backbone',
  'templates'
], (Backbone, Templates) ->

	class LingBlingView extends Backbone.View

		initialize: ->
			@model.on('change:page', @_updatePage)
			@model.on('change:user', @_updateUser)

			$('body').html Handlebars.templates['MainView'](@model.googleAuth)

			@signInButton = $('#sign-in-button')
			@signOutButton = $('#sign-out-button')

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
				@signOutButton.show()
			else
				@signOutButton.hide()
				@signInButton.show()

)
