DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Collection extends Backbone.View
  className: "posts"

  initialize: ->
    @listenTo app.collections.posts, "sync", @render

  addAll: ->
    @$el.empty()
    app.collections.posts.each @addOne

  addOne: (post) =>
    view = new DeadchanNet.Views.Posts.Item
      model: post
    @$el.append view.render().el

  render: ->
    if app.collections.posts.length
      @$el.show()
      @addAll()
      @setShowMore()
    else
      @$el.hide()
    @

  setShowMore: ->
    @$el.find('article .content').each ->
      $container = $(@).parent()
      if @.scrollHeight > $(@).height()
        $container.append('<a id="show-more" href="#">Читать дальше</div>')
