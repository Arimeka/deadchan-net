class DeadchanNet.Models.Post extends Backbone.Model
  defaults:
    _id: 0
    content: ''
    created_at: ''
    replies: []
    image: ''
    image_thumb: ''
    tread_id: 0
    board_abbr: ''

class DeadchanNet.Collections.PostsCollection extends Backbone.Collection
  url: -> "/treads/#{@meta('id')}"

  model: DeadchanNet.Models.Post

  initialize: ->
    @_meta = {};

  comparator: (post) ->
    post.get 'created_at'

  meta: (prop, value) ->
    if typeof value is "undefined"
      return @_meta[prop]
    else
      @_meta[prop] = value
