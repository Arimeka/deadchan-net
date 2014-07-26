DeadchanNet.Views.Boards ||= {}

class DeadchanNet.Views.Boards.Show extends Backbone.View
  el: '#board'

  events:
    'click .tread-form button#answer' : 'showForm'
    'click .tread-form button#hide'   : 'hideForm'
    'click .post-form button#answer'  : 'showPostForm'
    'click .post-form button#hide'    : 'hidePostForm'

  initialize: (attributes) ->
    @attributes = attributes

  showForm: (e) ->
    e.preventDefault()
    $container = $(e.currentTarget).closest('.tread-form')
    $btnHide = $container.find('button#hide')

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    app.views.treadForm = new DeadchanNet.Views.Treads.Form
                                abbr:     @attributes.abbr
    $container.find('#form').html app.views.treadForm.render().el

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.tread-form')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.treadForm.remove()

  showPostForm: (e) ->
    e.preventDefault()
    $container = $(e.currentTarget).closest('.post-form')
    $btnHide = $container.find('button#hide')
    data = e.currentTarget.dataset

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    app.views.postForm = new DeadchanNet.Views.Posts.Form
                                abbr:     data.abbr
                                treadId:  data.id
                                redirect: true
    $container.find('#form').html app.views.postForm.render().el

  hidePostForm: (e) ->
    $container = $(e.currentTarget).closest('.post-form')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.postForm.remove()