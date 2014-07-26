class DeadchanNet.Routers.ApplicationRouter extends Backbone.Router
  routes:
    ':abbr/:id'     :  'treadShow'
    ':abbr'         :  'boardShow'

  treadShow: (abbr, id) ->
    new DeadchanNet.Views.Treads.Show
        abbr:     abbr
        treadId:  id
    $posts = $("#posts")
    app.collections.posts = new DeadchanNet.Collections.PostsCollection
    app.collections.posts.meta 'id', id

  boardShow: (abbr) ->
    new DeadchanNet.Views.Boards.Show
        abbr: abbr
