DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Collection extends Backbone.View
  className: "posts"

  initialize: ->
    @listenTo app.collections.posts, 'reset', @render

  render: ->
    @$el.empty()
    container = document.createDocumentFragment()
    app.collections.posts.each (post) ->
      view = new DeadchanNet.Views.Posts.Item
              model: post
      container.appendChild view.render().el
    @$el.append container
    @
