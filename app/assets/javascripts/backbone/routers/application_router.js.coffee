class DeadchanNet.Routers.ApplicationRouter extends Backbone.Router
  routes:
    ':abbr/:id'     :  'treadShow'
    ':abbr'         :  'boardShow'

  treadShow: (abbr, id) ->
    app.views.treadShow = new DeadchanNet.Views.Treads.Show
    $posts = $("#posts")
    app.collections.posts = new DeadchanNet.Collections.PostsCollection
    app.collections.posts.meta 'id', id

  boardShow: (abbr) ->
    app.views.boardShow = new DeadchanNet.Views.Boards.Show
