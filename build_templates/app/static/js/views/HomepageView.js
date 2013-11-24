/**
  
  filname: HomepageView.js
  author: gregory tomlinson

  requires: backbone.js, jQuery

*/
define([
  "app",
  "mustache",
  "text!templates/homepage.html",
], function(App, Mustache, template) {

  App.HomepageView = Backbone.View.extend({
    tagName:"div",
    className:"homepageView",
    template:template,
    initialize:function() {
      console.log("App.HomepageView()");

      this.model = new Backbone.Model();
      this.model.on("sync", function() {
        this.render();
      }, this);
      this.model.fetch({});
    },
    render:function(data){
      var data = data || {};
      this.$el.html(Mustache.render(this.template,data));
      return this;
    }
  });

});