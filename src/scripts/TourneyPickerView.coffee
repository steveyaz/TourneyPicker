define([
  'backbone',
  'templates'
], (Backbone, Templates) ->

	class TourneyPickerView extends Backbone.View

		initialize: ->
			@model.on('change:page', @_updatePage)
			$('body').html Handlebars.templates['MainView']()
			# $('body').html Handlebars.templates['GoogleSignin']({
			# 	signinCallback: 'googleSigninCallback',
			# 	appId: '722928241069'
			# })
			# googleAuth = new GoogleAuth()
			# googleAuth.on('change:accessToken', @model.onLogin)
			# window.googleSigninCallback = googleAuth.signinCallback

		_updatePage: =>
			page = @model.get('page')
			
			# update the header links if necessary
			$('.nav').children('li').each ->
				$(@).removeClass('active')
			if page.getLabel?
				$('#' + page.getLabel() + '-link').addClass('active')

			page.show()
			page.render()

)
