class DeadchanNetBackend.Routers.ApplicationRouter extends Backbone.Router
  routes:
    'lodge/boards/:id'     :  'boardShow'
    'lodge/treads/:id'     :  'treadShow'

  boardShow: ->
    new DeadchanNetBackend.Views.Boards.Show

  treadShow: ->
    new DeadchanNetBackend.Views.Threads.Show
