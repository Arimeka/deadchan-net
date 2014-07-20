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

$ ->
  window.app ||= {}
  app.views ||= {}
  app.collections ||= {}
  app.router ||= new DeadchanNet.Routers.ApplicationRouter

  Backbone.history.start(pushState: true) unless Backbone.History.started
  $(document).on "page:change", ->
    Backbone.history.stop()
    Backbone.history.start(pushState: true)