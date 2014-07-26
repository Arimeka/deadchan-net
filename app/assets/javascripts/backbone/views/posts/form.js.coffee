DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Form extends Backbone.View
  idName: 'new_post'

  events:
    'ajax:success'          : 'ajaxSuccess'
    'click .upload-file'    : 'fileClick'
    'change #fileupload'    : 'fileupload'

  initialize: (attributes) ->
    @attributes = attributes

  render: ->
    $.ajax
      url: "/treads/form/#{@attributes.abbr}/#{@attributes.treadId}"
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
          if data.app.reload
            window.location.reload()
          else
            @$('form').trigger('reset')
            @$('textarea').val('')
            @$('.uploading-filename').empty()
            postsCollection = new DeadchanNet.Views.Posts.Collection
            a = $posts.html postsCollection.render().el
            $('html, body').animate(
              {scrollTop: $(a).find('article').last().offset().top
              })