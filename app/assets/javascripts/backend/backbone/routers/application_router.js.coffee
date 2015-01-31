class DeadchanNetBackend.Routers.ApplicationRouter extends Backbone.Router
  routes:
    'lodge/boards/:id'     :  'boardShow'


  boardShow: (abbr, id) ->
    console.log 'barfoo'
    new DeadchanNetBackend.Views.Boards.Show
