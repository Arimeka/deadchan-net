DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.Item extends Backbone.View
  template: JST["backbone/templates/posts/post"]

  tagName: "article"
  className: "well"


  events:
    'mouseenter li.reply'            : 'showReply'
    'mouseleave li.reply'            : 'hideReply'

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
    @replyTimer = setTimeout (->
      $reply = $(e.currentTarget)
      url = $reply.find('a').attr('href').replace('#', '/')
      if $reply.find('article').length == 0
        $loader = document.createElement 'article'
        $($loader).addClass 'well'
        $($loader).addClass 'article-loading'
        $($loader).append '<div class="article-loader"></div>'

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

            $element = view.render().el
            $reply.append $element
            rect = $element.getBoundingClientRect();
            $($element).css('width', $(window).width() - rect.left - 50)
        })
      else
        $reply.children('article').show()
    ), 1000

  hideReply: (e) ->
    clearTimeout @replyTimer
    $(e.currentTarget).find('article').hide()
