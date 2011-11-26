class Gemhub.Collections.Repos extends Backbone.Collection

  model: Gemhub.Models.Repo
  user_id: null

  fetch: ->
    socket = new WebSocket("ws://localhost:9000/watched_repos")

    socket.onopen = =>
      socket.send(@user_id)

    socket.onmessage = (msg) =>
      repo = JSON.parse(msg.data)
      this.add(repo)

    socket.onclose = =>
      console.log "CLOSED"
