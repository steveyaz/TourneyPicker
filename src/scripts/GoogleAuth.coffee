define([
  'backbone'
], ->

  class GoogleAuth extends Backbone.Model

    signinCallback: (authResult) =>
      if authResult['access_token']?
        @set('accessToken', authResult['access_token'])
        console.log('Login successful');
      else if authResult['error']
        # Possible error codes:
        #   "access_denied" - User denied access to your app
        #   "immediate_failed" - Could not automatically log in the user
        console.log('There was an error: ' + authResult['error']);

    disconnectUser: =>
      revokeUrl = 'https://accounts.google.com/o/oauth2/revoke?token=' + @accessToken

      # Perform an asynchronous GET request.
      $.ajax
        type: 'GET'
        url: revokeUrl
        async: false
        contentType: "application/json"
        dataType: 'jsonp'
        success: (nullResponse) ->
          console.log 'Revoked successfully'
        error: (e) ->
          console.log e
          # You could point users to manually disconnect if unsuccessful
          # https://plus.google.com/apps
)
