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
    window.app ||= {}
    app.views ||= {}
    app.collections ||= {}
    app.router ||= new DeadchanNet.Routers.ApplicationRouter
    Backbone.history.start pushState: true

$ ->
  $(document).ready ->
    Backbone.history.stop()
    DeadchanNet.initialize()



