DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Show extends Backbone.View
  el: '#tread'

  events:
    'click .post-form button#answer' : 'showForm'
    'click .post-form button#hide'   : 'hideForm'

  initialize: (attributes) ->
    @attributes = attributes

  showForm: (e) ->
    e.preventDefault()
    if app.views.postForm
      @toggleForm(e)
    else
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

  toggleForm: (e) ->
    e.preventDefault()
    $container = $(e.currentTarget).closest('.post-form')
    $btnHide = $container.find('button#hide')
    data = e.currentTarget.dataset

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    $form = $container.find('#form')

    oldView = app.views.postForm
    $oldForm = app.views.postForm.$el

    app.views.postForm = new DeadchanNet.Views.Posts.Form

    app.views.postForm.$el = $oldForm.clone().appendTo $form
    app.views.postForm.$el.attributes = {abbr: data.abbr, treadId:  data.id}
    app.views.postForm.$el.find('form')[0].action = "/#{data.abbr}/#{data.id}"

    oldView.delegateEvents app.views.postForm.events
    app.views.postForm.delegateEvents()

    unless typeof(Recaptcha) == 'undefined'
      eval($('.captcha script').html())

    @toggleButtons($oldForm)
    oldView.remove()

  toggleButtons: (elem) ->
    $container = $(elem).closest('.post-form')
    $container.find('button#answer').toggle()
    $container.find('button#hide').toggle()
