require.config({
  paths: {
    jquery: 'lib/jquery-2.0.3.min',
    underscore: 'lib/underscore-min',
    backbone: 'lib/backbone-min',
    handlebars: 'lib/handlebars',
    datepicker: 'lib/bootstrap-datepicker',
    bootstrap: 'lib/bootstrap.min',
    templates: 'templates/templates',
    LingBlingRouter: 'scripts/LingBlingRouter',
    LingBlingModel: 'scripts/LingBlingModel',
    LingBlingView: 'scripts/LingBlingView',
    LingBlingPage: 'scripts/LingBlingPage',
    BrowseTournamentsModel: 'scripts/BrowseTournamentsModel',
    BrowseTournamentsView: 'scripts/BrowseTournamentsView',
    CreateTournamentModel: 'scripts/CreateTournamentModel',
    CreateTournamentView: 'scripts/CreateTournamentView',
    OverviewModel: 'scripts/OverviewModel',
    OverviewView: 'scripts/OverviewView',
    ProfileModel: 'scripts/ProfileModel',
    ProfileView: 'scripts/ProfileView',
    TournamentModel: 'scripts/TournamentModel',
    TournamentView: 'scripts/TournamentView',
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
      deps: ['handlebars'],
      exports: 'Templates'
    }
  }
});

require(['LingBlingRouter'], function(LingBling) {
	new LingBling()
});
