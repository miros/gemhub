class window.RepoFetcher

  constructor: (@user_id) ->

  run: ->
    repos = new Gemhub.Collections.Repos
    repos.user_id = @user_id

    view = new Gemhub.Views.ReposIndex(collection: repos)
    view.render()

    repos.fetch()