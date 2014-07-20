class DeadchanNet.Views.FormView extends Backbone.View
  el: '#new_post'

  events:
    'ajax:success'          : 'ajaxSuccess'

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
          @$('textarea').val('')
          postsIndexView = new DeadchanNet.Views.Posts.IndexView
          a = $posts.html postsIndexView.render().el
          $('html, body').animate(
            {scrollTop: $(a).find('article').last().offset().top
            })