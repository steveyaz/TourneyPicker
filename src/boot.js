require.config({
  paths: {
    jquery: 'lib/jquery-2.0.3.min',
    underscore: 'lib/underscore-min',
    backbone: 'lib/backbone-min',
    TourneyPickerRouter: 'js/TourneyPickerRouter',
    TourneyPickerModel: 'js/TourneyPickerModel',
    TourneyPickerView: 'js/TourneyPickerView'
  },
  shim: {
  	underscore: {
  		exports: '_'
  	},
  	backbone: {
  		deps: ['underscore', 'jquery'],
  		exports: 'Backbone'
  	}
  }
});

require(['TourneyPickerRouter'], function(TourneyPickerRouter) {
	new TourneyPickerRouter()
});
