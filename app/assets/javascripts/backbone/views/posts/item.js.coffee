DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Item extends Backbone.View
  template: JST["backbone/templates/posts/post"]

  tagName: "article"
  className: "well"


  events:
    'mouseenter li.reply'            : 'showReply'
    'mouseenter a.parent-post'       : 'showParent'
    'mouseleave li.reply'            : 'resetTimer'
    'mouseleave a.parent-post'       : 'resetTimer'
    'mouseleave article'             : 'hideReply'
    'mouseleave .parent-list'        : 'hideReply'
    'mouseleave .reply-list'         : 'hideReply'

  initialize: ->
    if @model.collection?
      @model.set tread_id: @model.collection.meta('id')
      @model.set board_abbr: @model.collection.meta('abbr')

  attributes: ->
    id: @model.get('_id').$oid

  render: ->
    @$el.html @template(@model.toJSON())
    @

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
    @resetTimer()
    $(e.currentTarget).find('article').hide()

  showPost: (container, url, position) ->
    if container.find('article').length == 0
      $loader = document.createElement 'article'
      $($loader).addClass 'well'
      $($loader).addClass 'article-loading'
      $($loader).append '<div class="article-loader"></div>'

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

          $element = view.render().el
          container.append $element
          rect = $element.getBoundingClientRect();

          $($element).css('width', $(window).width() - rect.left - 50)
          $($element).css('margin-top', position.marginTop)
          $($element).css('left', -position.left)
          $($element).css('top', -position.top)
      })
    else
      container.children('article').show()

  resetTimer: ->
    clearTimeout @replyTimer
