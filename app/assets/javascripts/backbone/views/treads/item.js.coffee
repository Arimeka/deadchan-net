DeadchanNet.Views.Treads ||= {}

class DeadchanNet.Views.Treads.Item extends Backbone.View
  template: JST["backbone/templates/treads/tread"]

  tagName: "article"
  className: "well"

  events:
    'mouseenter li.reply'            : 'showReply'
    'mouseleave li.reply'            : 'hideReply'

  attributes: ->
    id: @model.get('_id').$oid

  render: ->
    @$el.html @template(@model.toJSON())
    @

  showReply: (e) ->
    e.stopPropagation()
    @replyTimer = setTimeout (->
      $reply = $(e.currentTarget)
      url = $reply.find('a').attr('href').replace('#', '/')
      if $reply.find('article').length == 0
        $loader = $(document.createElement 'article')
        $loader.addClass 'well'
        $loader.addClass 'article-loading'
        $loader.append '<div class="article-loader"></div>'

        $.ajax({
          url: url
          dataType: 'json'
          beforeSend: ->
            $reply.append $loader
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
            $reply.append element
            rect = element.getBoundingClientRect();
            $(element).css('width', $(window).width() - rect.left - 50)
          error: ->
            $sad = $(document.createElement 'article')
            $sad.addClass 'well'
            $sad.addClass 'article-sad'
            $sad.append '<div class="article-smile"></div>'
            $reply.append $sad
        })
      else
        $reply.children('article').show()
    ), 1000

  hideReply: (e) ->
    clearTimeout @replyTimer
    $(e.currentTarget).find('article').hide()
