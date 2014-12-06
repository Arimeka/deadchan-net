DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Show extends Backbone.View
  el: '#tread'

  events:
    'click .post-form button#answer' : 'showForm'
    'click .post-form button#hide'   : 'hideForm'
    'mouseenter li.reply'            : 'showReply'
    'mouseleave li.reply'            : 'hideReply'

  initialize: (attributes) ->
    @attributes = attributes
    @checkCommentable()

  showForm: (e) ->
    e.preventDefault()
    if app.views.postForm
      @toggleForm(e)
    else
      $container = $(e.currentTarget).closest('.post-form')
      $btnHide = $container.find('button#hide')
      data = e.currentTarget.dataset

      $(e.currentTarget).toggle()
      $btnHide.toggle()

      app.views.postForm = new DeadchanNet.Views.Posts.Form
                                  abbr:     @attributes.abbr
                                  treadId:  @attributes.treadId
      $container.find('#form').html app.views.postForm.render().el
      if data.reply?
        app.views.postForm.$el.find('#post_content')[0].value = "+#{data.reply}"

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.post-form')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.postForm.remove()

  showReply: (e) ->
    e.stopPropagation()
    @replyTimer = setTimeout (->
      $reply = $(e.currentTarget)
      url = $reply.find('a').attr('href').replace('#', '/')
      if $reply.find('article').length == 0
        $.ajax({
          url: url,
          dataType: 'json'
          success: (data) ->
            if data['tread_id']?
              post = new DeadchanNet.Models.Post data
              post.set board_abbr: url.split('/')[1]

              view = new DeadchanNet.Views.Posts.Item
                          model: post
            else
              tread = new DeadchanNet.Models.Tread data
              tread.set board_abbr: url.split('/')[1]

              view = new DeadchanNet.Views.Treads.Item
                          model: tread

            $element = view.render().el
            $reply.append $element
            rect = $element.getBoundingClientRect();
            $($element).css('width', $(window).width() - rect.left - 50)
        })
      else
        $reply.children('article').show()
    ), 1000

  hideReply: (e) ->
    clearTimeout @replyTimer
    $(e.currentTarget).find('article').hide()


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
    if data.reply
      app.views.postForm.$el.find('#post_content')[0].value = "+#{data.reply}"

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

  checkCommentable: ->
    if $('.thread>article .post-form button').length == 0
      $('.post-form button').hide()
