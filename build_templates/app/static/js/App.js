/***

  requires
    jQuery.js, backbone.js, mustache.js

*/

(function() {

  window.App = window.App || {
    VERSION: 'Oct 7, 2013 11:19am',
    DEBUG: false
  };


  App.start = function() {
    console.log("The app starts")

    App.router = new App.WorkspaceRouter();
    Backbone.history.start({pushState: true}); 
  }

})();