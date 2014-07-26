DeadchanNet.Views.Boards ||= {}

class DeadchanNet.Views.Boards.Show extends Backbone.View
  el: '#board'

  events:
    'click button#answer' : 'showForm'
    'click button#hide'   : 'hideForm'

  initialize: (attributes) ->
    @attributes = attributes

  showForm: (e) ->
    e.preventDefault()
    $container = $(e.currentTarget).closest('.form-answer')
    $btnHide = $container.find('button#hide')

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    app.views.treadForm = new DeadchanNet.Views.Treads.Form
                                abbr:     @attributes.abbr
    $container.find('#form').html app.views.treadForm.render().el

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.form-answer')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.treadForm.remove()