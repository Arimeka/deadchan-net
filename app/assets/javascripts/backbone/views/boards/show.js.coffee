DeadchanNet.Views.Boards ||= {}

class DeadchanNet.Views.Boards.Show extends Backbone.View
  el: '#board'

  events:
    'click button#answer' : 'showForm'
    'click button#hide'   : 'hideForm'

  showForm: (e) ->
    e.preventDefault()
    $container = $(e.currentTarget).closest('.form-answer')
    $btnHide = $container.find('button#hide')

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    @$('#form').clone().insertAfter($btnHide).show()

    new DeadchanNet.Views.Treads.Form

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.form-answer')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    $container.find('#form').remove()