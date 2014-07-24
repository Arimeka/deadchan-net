DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Form extends Backbone.View
  el: '#new_tread'

  events:
    'click .upload-file'    : 'fileClick'
    'change #fileupload'    : 'fileupload'

  fileClick: (e) ->
    e.preventDefault()
    @$('#fileupload').click()

  fileupload: (e) ->
    @$('.uploading-filename').text $(e.currentTarget).val()