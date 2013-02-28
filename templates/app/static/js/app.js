/**


requires
  jQuery.js, backbone.js, mustache.js

*/

Mustache.tags = ["<%=", "%>"]; 
// tonardo steals }} {{
var helpView = {

  title:"help view"
};
var WorkspaceRouter = Backbone.Router.extend({
  routes:{
    "" : "homepage",
    "help":"help"
  },
  homepage:function() {
    console.log(arguments);
    return this;
  },
  help:function() {
    var output = Mustache.render("<h1>this is <%=title%></h1>", helpView);
    $(".container").append(output);
  }
});

/**EOF*/