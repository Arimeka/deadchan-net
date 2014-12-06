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
        $.ajax({
          url: url,
          dataType: 'json'
          success: (data) ->
            post = new DeadchanNet.Models.Post data
            post.set board_abbr: url.split('/')[1]

            view = new DeadchanNet.Views.Posts.Item
                        model: post
            $element = view.render().el
            $reply.append $element
            rect = $element.getBoundingClientRect();
            $($element).css('width', $(window).width() - rect.left - 50)
        })
    ), 1000

  hideReply: (e) ->
    clearTimeout @replyTimer
    $(e.currentTarget).find('article').remove()
