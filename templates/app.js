

Mustache.tags = ["<%=", "%>"]; 
// tonardo steals {{ }}
var helpView = {

  title:"help view"
};
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
    var output = Mustache.render("<h1>this is <%=title%></h1>", helpView);
    $(".container").append(output);
  }
});

