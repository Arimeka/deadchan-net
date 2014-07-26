DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Form extends Backbone.View
  idName: 'new_tread'

  events:
    'ajax:success'          : 'ajaxSuccess'
    'click .upload-file'    : 'fileClick'
    'change #fileupload'    : 'fileupload'

  initialize: (attributes) ->
    @attributes = attributes

  render: ->
    $.ajax
      url: "/boards/form/#{@attributes.abbr}"
      async: false
      success: (data) =>
        @$el.html data
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
    else
      window.location.replace data.app.redirect