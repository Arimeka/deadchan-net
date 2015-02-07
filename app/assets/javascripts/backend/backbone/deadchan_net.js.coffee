#= require_self
#= require_tree ./views
#= require_tree ./routers
#= require raphael/raphael-min
#= require morrisjs/morris.min

window.DeadchanNetBackend =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  initialize: ->
    handlersLength = Backbone.history.handlers.length
    window.app ||= {}
    app.views ||= {}
    app.collections ||= {}
    app.router ||= new DeadchanNetBackend.Routers.ApplicationRouter
    Backbone.history.start pushState: true

$ ->
  $(document).ready ->
    Backbone.history.stop()
    DeadchanNetBackend.initialize()

    $('#datetimepicker').datetimepicker
      format: 'YYYY-MM-DD HH:mm:ss'
