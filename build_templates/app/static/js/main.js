requirejs.config({
    //By default load any module IDs from js/lib
  baseUrl: '/static/js',
  waitSeconds: 10000,
  urlArgs: "_r=" + (new Date()).getTime(), // for developing
  shim: {


    backbone: {
      deps: ['underscore', 'jquery'],
      //Once loaded, use the global 'Backbone' as the
      //module value.
      exports: 'Backbone'
    },
    underscore: {
        exports: '_'
    },
    mustache: {
      deps: ['jquery'],  
      exports: 'Mustache'
    },  


    app: {
      deps: ["backbone", "mustache"],
      exports: 'App'
    }
  
  },

  paths: {
    jquery: "libs/jquery-1.10.2",
    backbone:"libs/backbone",
    underscore:"libs/underscore",
    mustache:"libs/mustache",
    app: "App",
    templates: '../templates'
    
  }
});

// Start the main app logic.
requirejs([
    'app',
    'WorkspaceRouter',
 

  ], function(App) {
    // kick off everthing here
    App.start();
});
