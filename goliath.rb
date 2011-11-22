require 'bundler/setup'
Bundler.require(:default)

require 'goliath'
require 'goliath/websocket'

require 'em-synchrony/em-http'
require 'em-synchrony/mongoid'

require_relative "app/models/user"

Mongoid.load!(File.join(File.dirname(__FILE__), 'config/mongoid.yml'))

class WebsocketEndPoint < Goliath::WebSocket

  def on_message(env, msg)
    env.logger.info(msg)
    EM.synchrony {
      user = User.find(msg)
      user.each_watched_repo {|repo| env.stream_send(repo.to_json)}
    }
  end

  def on_error(env, error)
    env.logger.error(error)
  end

end

class Websocket < Goliath::API
  map '/watched_repos', WebsocketEndPoint
end