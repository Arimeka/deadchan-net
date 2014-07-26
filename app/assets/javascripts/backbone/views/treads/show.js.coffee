DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Show extends Backbone.View
  el: '#tread'

  events:
    'click .post-form button#answer' : 'showForm'
    'click .post-form button#hide'   : 'hideForm'

  initialize: (attributes) ->
    @attributes = attributes

  showForm: (e) ->
    $container = $(e.currentTarget).closest('.post-form')
    $btnHide = $container.find('button#hide')

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    app.views.postForm = new DeadchanNet.Views.Posts.Form
                                abbr:     @attributes.abbr
                                treadId:  @attributes.treadId
    $container.find('#form').html app.views.postForm.render().el

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.post-form')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.postForm.remove()