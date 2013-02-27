

Mustache.tags = ["<%=", "%>"]; 
// tonardo steals {{ }}

var WorkspaceRouter = Backbone.Router.extend({
  routes:{
    "" : "homepage",
    "help":"help"
  },
  homepage:function() {
    console.log("I am the homepage - w00t")
    return this;
  },
  help:function() {
    console.log("go go help");

  }
});

