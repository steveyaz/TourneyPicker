require.config({
  paths: {
    jquery: 'lib/jquery-2.0.3.min',
    underscore: 'lib/underscore-min',
    backbone: 'lib/backbone-min',
    handlebars: 'lib/handlebars',
    templates: 'templates/templates',
    TourneyPickerRouter: 'scripts/TourneyPickerRouter',
    TourneyPickerModel: 'scripts/TourneyPickerModel',
    TourneyPickerView: 'scripts/TourneyPickerView',
    GoogleAuth: 'scripts/GoogleAuth'
  },
  shim: {
  	underscore: {
  		exports: '_'
  	},
  	backbone: {
  		deps: ['underscore', 'jquery'],
  		exports: 'Backbone'
  	},
    handlebars: {
      exports: 'Handlebars'
    },
    templates: {
      exports: 'Templates',
      deps: ['handlebars']
    }
  }
});

require(['TourneyPickerRouter'], function(TourneyPickerRouter) {
	new TourneyPickerRouter()
});
