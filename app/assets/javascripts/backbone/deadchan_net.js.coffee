#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.DeadchanNet =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  initialize: ->
    handlersLength = Backbone.history.handlers.length
    window.app ||= {}
    app.views ||= {}
    app.collections ||= {}
    app.router ||= new DeadchanNet.Routers.ApplicationRouter
    # Ugly fix for problems with firing router twice
    if handlersLength == 0
      Backbone.history.start pushState: true
    else
      Backbone.history.checkUrl()

$ ->
  $(document).ready ->
    DeadchanNet.initialize()



