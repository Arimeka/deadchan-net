DeadchanNet.Views.Posts ||= {}

class DeadchanNet.Views.Posts.PostView extends Backbone.View
  template: JST["backbone/templates/posts/post"]

  tagName: "article"
  className: "well"

  initialize: ->
    @model.set tread_id: @model.collection.meta('id')

  attributes: ->
    id: @model.get('_id').$oid

  render: ->
    @$el.html @template(@model.toJSON())
    @