class DeadchanNet.Models.Post extends Backbone.Model
  defaults:
    _id: 0
    content: ''
    created_at: ''
    is_published: true
    updated_at: ''
    tread_id: 0

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