DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Form extends Backbone.View
  idName: 'new_tread'

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

  render: (content, title) ->
    $.ajax
      url: "/boards/form/#{@attributes.abbr}"
      async: false
      success: (data) =>
        @$el.html data
        if content?
          @$el.find('textarea').val(content)
        if title?
          @$el.find('#tread_title').val(title)
        @$el.attributes = {abbr: @attributes.abbr, redirect: @attributes.redirect}
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
      window.location.replace data.app.redirect

  ajaxError: ->
    $submitButton = @$el.find('input[type="submit"]')
    $submitButton.prop('disabled', false)
    content = @$el.find('textarea').val()
    title = @$el.find('#tread_title').val()
    app.views.treadForm = new DeadchanNet.Views.Treads.Form
                                abbr:     @$el.attributes.abbr
                                redirect: @$el.attributes.redirect
    @$el.closest('#form').html app.views.treadForm.render(content, title).el
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
