require.config({
  paths: {
    jquery: 'lib/jquery-2.0.3.min',
    underscore: 'lib/underscore-min',
    backbone: 'lib/backbone-min',
    handlebars: 'lib/handlebars',
    datepicker: 'lib/bootstrap-datepicker',
    templates: 'templates/templates',
    TourneyPickerRouter: 'scripts/TourneyPickerRouter',
    TourneyPickerModel: 'scripts/TourneyPickerModel',
    TourneyPickerView: 'scripts/TourneyPickerView',
    TourneyPickerPage: 'scripts/TourneyPickerPage',
    BrowseTournamentsModel: 'scripts/BrowseTournamentsModel',
    BrowseTournamentsView: 'scripts/BrowseTournamentsView',
    CreateTournamentModel: 'scripts/CreateTournamentModel',
    CreateTournamentView: 'scripts/CreateTournamentView',
    OverviewModel: 'scripts/OverviewModel',
    OverviewView: 'scripts/OverviewView',
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
    datepicker: {
      exports: 'datepicker'
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
