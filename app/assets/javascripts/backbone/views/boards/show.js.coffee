DeadchanNet.Views.Boards ||= {}

class DeadchanNet.Views.Boards.Show extends Backbone.View
  el: '#board'

  events:
    'click .tread-form button#answer' : 'showForm'
    'click .tread-form button#hide'   : 'hideForm'
    'click .post-form button#answer'  : 'showPostForm'
    'click .post-form button#hide'    : 'hidePostForm'
    'mouseenter li.reply'             : 'showReply'
    'mouseenter a.parent-post'        : 'showParent'
    'mouseleave li.reply'             : 'resetTimer'
    'mouseleave a.parent-post'        : 'resetTimer'
    'mouseleave article'              : 'hideReply'
    'mouseleave .parent-list'         : 'hideReply'
    'mouseleave .reply-list'          : 'hideReply'
    'click a.attachment'              : 'showFullsize'
    'click #show-more'                : 'showMore'
    'click #hide-more'                : 'hideMore'

  initialize: (attributes) ->
    @attributes = attributes
    @checkCommentable()
    @setShowMore()

    $('#modal').on('hidden.bs.modal', (e) ->
      $(@).html ''
    )

    $('#modal').on('shown.bs.modal', (e) ->
      wheelzoom($(@).find('img'), {zoom:0.005})
    )

  showForm: (e) ->
    e.preventDefault()
    $container = $(e.currentTarget).closest('.tread-form')
    $btnHide = $container.find('button#hide')

    $(e.currentTarget).toggle()
    $btnHide.toggle()

    app.views.treadForm = new DeadchanNet.Views.Treads.Form
                                abbr:     @attributes.abbr
    $container.find('#form').html app.views.treadForm.render().el

  hideForm: (e) ->
    $container = $(e.currentTarget).closest('.tread-form')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.treadForm.remove()

  showPostForm: (e) ->
    e.preventDefault()
    if app.views.postForm
      @togglePostForm(e)
    else
      $container = $(e.currentTarget).closest('.post-form')
      $btnHide = $container.find('button#hide')
      data = e.currentTarget.dataset

      $(e.currentTarget).toggle()
      $btnHide.toggle()

      app.views.postForm = new DeadchanNet.Views.Posts.Form
                                  abbr:     data.abbr
                                  treadId:  data.id
                                  redirect: true
      $container.find('#form').html app.views.postForm.render().el
      if data.reply?
        app.views.postForm.$el.find('#post_content')[0].value = "+#{data.reply}"

  hidePostForm: (e) ->
    $container = $(e.currentTarget).closest('.post-form')

    $(e.currentTarget).toggle()
    $container.find('button#answer').toggle()

    app.views.postForm.remove()

  showReply: (e) ->
    e.stopPropagation()
    $that = @
    @replyTimer = setTimeout (->
      $reply = $(e.currentTarget)
      $body = $reply.closest('article')
      url = $reply.find('a').attr('href').replace('#', '/')

      $container = $body.find(".reply-list[data-href='#{url}']")
      unless $container.length
        $body.append("<div class='reply-list' data-href='#{url}'></div>")
        $container = $body.find(".reply-list[data-href='#{url}']")

      position =
        {
          top: $container.offset().top - $reply.offset().top,
          left: $container.offset().left - $reply.offset().left,
          marginTop: $reply.height()
        }

      $that.showPost($container, url, position)
    ), 1000

  showParent: (e) ->
    e.stopPropagation()
    $that = @
    @replyTimer = setTimeout (->
      $reply = $(e.currentTarget)
      $body = $reply.closest('article')
      url = $reply.attr('href').replace('#', '/')

      $container = $body.find(".parent-list[data-href='#{url}']")
      unless $container.length
        $body.append("<div class='parent-list' data-href='#{url}'></div>")
        $container = $body.find(".parent-list[data-href='#{url}']")

      position =
        {
          top: $container.offset().top - $reply.offset().top,
          left: $container.offset().left - $reply.offset().left,
          marginTop: $reply.height()
        }

      $that.showPost($container, url, position)
    ), 1000

  hideReply: (e) ->
    clearTimeout @replyTimer
    $(e.currentTarget).find('article').hide()

  showFullsize: (e) ->
    e.preventDefault()
    $modal = $('#modal')
    src =  $(e.currentTarget).attr('href')
    $modal.html "<img src='#{src}' class='img-rounded'>"
    $modal.find('img').css('max-height',"#{$(window).height() - 200}px")

    $('#modal').modal('show')

  togglePostForm: (e) ->
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
    app.views.postForm.$el.attributes = {abbr: data.abbr, treadId:  data.id, redirect: true}
    app.views.postForm.$el.find('form')[0].action = "/#{data.abbr}/#{data.id}"
    if data.reply
      app.views.postForm.$el.find('#post_content')[0].value = "+#{data.reply}"

    oldView.delegateEvents app.views.postForm.events
    app.views.postForm.delegateEvents()

    unless typeof(Recaptcha) == 'undefined'
      eval($('.captcha script').html())

    @togglePostButtons($oldForm)
    oldView.remove()

  togglePostButtons: (elem) ->
    $container = $(elem).closest('.post-form')
    $container.find('button#answer').toggle()
    $container.find('button#hide').toggle()

  checkCommentable: ->
    $('.thread').each ->
      if $(@).find('>article .post-form button').length == 0
        $(@).find('.post-form button').hide()

  showPost: (container, url, position) ->
    if container.find('article').length == 0
      $loader = $(document.createElement 'article')
      $loader.addClass 'well'
      $loader.addClass 'article-loading'
      $loader.append '<div class="article-loader"></div>'

      $.ajax({
        url: url
        dataType: 'json'
        beforeSend: ->
          container.append $loader
        complete: ->
          $loader.remove()
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

          element = view.render().el
          container.append element
          rect = element.getBoundingClientRect();
          $element = $(element)

          $element.css('width', $(window).width() - rect.left - 50)
          $element.css('margin-top', position.marginTop)
          $element.css('left', -position.left)
          $element.css('top', -position.top)
        error: ->
          $sad = $(document.createElement 'article')
          $sad.addClass 'well'
          $sad.addClass 'article-sad'
          $sad.append '<div class="article-smile"></div>'
          container.append $sad
      })
    else
      container.children('article').show()

  resetTimer: ->
    clearTimeout @replyTimer

  setShowMore: ->
    @$('article .content').each ->
      $container = $(@).parent()
      if @.scrollHeight > $(@).height()
        $container.append('<a id="show-more" href="#">Читать дальше</div>')

  showMore: (e) ->
    e.preventDefault()
    $showMoreButton = $(e.currentTarget)
    $content = $showMoreButton.closest('.body').find('.content')
    $container = $showMoreButton.parent()

    $showMoreButton.hide()
    $content.css('max-height', 'none')
    $content.css('overflow', 'visible')

    unless $container.find('#hide-more').length
      $container.append('<a id="hide-more" href="#">Скрыть</div>')
    else
      $container.find('#hide-more').show()

  hideMore: (e) ->
    e.preventDefault()
    $hideMoreButton = $(e.currentTarget)
    $content = $hideMoreButton.closest('.body').find('.content')
    $container = $hideMoreButton.parent()

    $hideMoreButton.hide()
    $content.css('max-height', '')
    $content.css('overflow', '')

    unless $container.find('#show-more').length
      $container.append('<a id="show-more" href="#">Скрыть</div>')
    else
      $container.find('#show-more').show()
