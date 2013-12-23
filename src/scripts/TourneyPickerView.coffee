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
			@_setActiveLabel(page.getLabel())
			page.show()
			page.render()

		_setActiveLabel: (pageLabel) =>
			$('.nav').children('li').each ->
				$(@).removeClass('active')

			$('#' + pageLabel + '-link').addClass('active')
			console.log 'test: ' + pageLabel

)
