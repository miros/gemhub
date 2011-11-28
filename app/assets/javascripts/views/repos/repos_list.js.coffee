class Gemhub.Views.ReposList extends Backbone.View

  template: JST['repos/list_item']

  initialize: ->
    @collection.bind("add", this.on_model_added)
    @collection.bind("reset", this.on_reset)

    console.log @collection

  render: ->

  empty: ->
    $(@el).html("")

  on_reset: =>
    this.empty()
    @collection.each (model) => this.on_model_added(model)

  on_model_added: (model) =>
    node = @template(model.toJSON())
    $(@el).append node




