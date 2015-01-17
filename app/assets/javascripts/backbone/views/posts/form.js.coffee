DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Form extends Backbone.View
  idName: 'new_post'

  events:
    'ajax:beforeSend'       : 'ajaxBeforeSend'
    'ajax:remotipartSubmit' : 'ajaxBeforeSend'
    'ajax:success'          : 'ajaxSuccess'
    'ajax:error'            : 'ajaxError'
    'ajax:complete'         : 'ajaxComplete'
    'click .upload-file'    : 'fileClick'
    'change #fileupload'    : 'fileupload'

  initialize: (attributes) ->
    @attributes = attributes

  render: (content) ->
    $.ajax
      url: "/treads/form/#{@attributes.abbr}/#{@attributes.treadId}"
      async: false
      success: (data) =>
        @$el.html data
        if content?
          @$el.find('textarea').val(content)
        @$el.attributes = {abbr: @attributes.abbr, treadId: @attributes.treadId, redirect: @attributes.redirect}
        @initialize()
    @


  fileClick: (e) ->
    e.preventDefault()
    @$('#fileupload').click()

  fileupload: (e) ->
    @$('.uploading-filename').text $(e.currentTarget).val()

  ajaxSuccess: (e, data, status, xhr)->
    if data.app.error
      for msg of data.app.error.text
        $('.top-right').notify
          message:
            text: data.app.error.text[msg]
          type: 'danger'
          closable: false
        .show()
      @$('.uploading-filename').text ''
      unless typeof(Recaptcha) == 'undefined'
        Recaptcha.reload()
    else
      for msg of data.app.notice.text
        $('.top-right').notify
          message:
            text: data.app.notice.text[msg]
          type: 'success'
          closable: false
        .show()
      if @$el.attributes && @$el.attributes.redirect
        window.location.replace "/#{@$el.attributes.abbr}/#{@$el.attributes.treadId}##{data.app.id.$oid}"
      else if data.app.reload
        window.location.reload()
      else
        $posts = $("#posts")
        app.collections.posts.fetch
          success: ->
            @$('form').trigger('reset')
            @$('textarea').val('')
            @$('.uploading-filename').empty()
            @$('button').click()
            postsCollection = new DeadchanNet.Views.Posts.Collection
            a = $posts.html postsCollection.render().el
            $('html, body').animate(
              {scrollTop: $(a).find('article').last().offset().top
              })

  ajaxError: ->
    submitButton = @$el.find('input[type="submit"]')
    $submitButton.prop('disabled', false)
    content = @$el.find('textarea').val()
    app.views.postForm = new DeadchanNet.Views.Posts.Form
                                abbr:     @$el.attributes.abbr
                                treadId:  @$el.attributes.treadId
    @$el.closest('#form').html app.views.postForm.render(content).el
    $('.top-right').notify
      message:
        text: 'Ошибка отправки формы, попробуйте еще раз'
      type: 'danger'
      closable: false
    .show()

  ajaxBeforeSend: ->
    $submitButton = @$el.find('input[type="submit"]')
    $submitButton.prop('disabled', true)

  ajaxComplete: ->
    $submitButton = @$el.find('input[type="submit"]')
    $submitButton.prop('disabled', false)
