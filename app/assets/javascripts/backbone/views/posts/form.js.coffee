DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Form extends Backbone.View
  el: '#new_post'

  events:
    'ajax:success'          : 'ajaxSuccess'
    'click .upload-file'    : 'fileClick'
    'change #fileupload'    : 'fileupload'

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
      $posts = $("#posts")
      app.collections.posts.fetch
        success: ->
          for msg of data.app.notice.text
            $('.top-right').notify
              message:
                text: data.app.notice.text[msg]
              type: 'success'
              closable: false
            .show()
          @$('form').trigger('reset')
          @$('textarea').val('')
          @$('.uploading-filename').empty()
          postsCollection = new DeadchanNet.Views.Posts.Collection
          a = $posts.html postsCollection.render().el
          $('html, body').animate(
            {scrollTop: $(a).find('article').last().offset().top
            })