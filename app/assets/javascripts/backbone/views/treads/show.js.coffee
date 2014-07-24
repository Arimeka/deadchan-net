DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Show extends Backbone.View
  el: '#tread'

  events:
    'click button#answer' : 'showForm'
    'click button#hide'   : 'hideForm'

  showForm: (e) ->
    $container = $(e.currentTarget).closest('.form-answer')
    $btnHide = $container.find('button#hide')

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    @$('#form').clone().insertAfter($btnHide).show()

    new DeadchanNet.Views.Posts.Form

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.form-answer')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    $container.find('#form').remove()