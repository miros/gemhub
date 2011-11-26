class Gemhub.Views.ReposIndex extends Backbone.View

  el: "#repos"
  template: JST['repos/index']

  initialize: ->
    this.collection.bind("add", this.on_model_added)

  render: ->

  on_model_added: (model) =>
    node = @template(model.toJSON())
    $(@el).append node




