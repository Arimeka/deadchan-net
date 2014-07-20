class DeadchanNet.Routers.ApplicationRouter extends Backbone.Router
  routes:
    ':abbr/:id':  'treadShow'

  treadShow: (abbr, id) ->
    $posts = $("#posts")
    app.collections.posts = new DeadchanNet.Collections.PostsCollection
    app.collections.posts.meta 'id', id
