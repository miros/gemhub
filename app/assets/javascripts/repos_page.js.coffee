class window.ReposPage extends Backbone.View

  el: "body"

  events:
    "click #reload-repos": "reload"

  initialize: (options) ->
    @collection = new Gemhub.Collections.Repos
    @collection.user_id = options.user_id
    this.render()

  reset: (new_repos) ->
    @collection.reset(new_repos)

  reload: ->
    console.log "RELOAD"
    @list.empty()
    @collection.fetch()

  render: ->
    @list = new Gemhub.Views.ReposList(el: "#repos", collection: @collection)
    @list.render()



