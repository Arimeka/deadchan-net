DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Collection extends Backbone.View
  className: "posts"

  initialize: ->
    @listenTo app.collections.posts, "sync", @render
    that = @
    @_views = []
    app.collections.posts.each (post) ->
      view = new DeadchanNet.Views.Posts.Item
        model: post
      that._views.push view

  render: ->
    @$el.empty()
    container = document.createDocumentFragment()
    _.each @_views, (postView) ->
      container.appendChild postView.render().el
    @$el.append container
    @
