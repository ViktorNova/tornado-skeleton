/**
  
  MobileRouter.js
  author: gregory tomlinson
  copyright: 2013

  application routing

*/

define(["app"], function(App) {

  console.log("workspace router")
  var DEBUG = false;
  App.currentView = null;
  App.WorkspaceRouter = Backbone.Router.extend({
  
    routes:{
      "":"homepage"
    },
    homepage:function() {

      App.homepageView = new App.HomepageView();
      $("#contentbody").html("").append(App.homepageView.render().el);
      
    }
  });

});