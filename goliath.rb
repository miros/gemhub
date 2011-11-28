require 'bundler/setup'
Bundler.require(:default)

require 'goliath'
require 'goliath/websocket'

require 'em-synchrony/em-http'
require 'em-synchrony/mongoid'
require 'em-synchrony/fiber_iterator'

#TODO add autoload here
require_relative "app/models/user"
require_relative "app/models/repo"
require_relative "app/models/repo_fetcher"
require_relative "app/models/ruby_toolbox_gateway"

Mongoid.load!(File.join(File.dirname(__FILE__), 'config/mongoid.yml'))

class WebsocketEndPoint < Goliath::WebSocket

  def on_message(env, msg)
    env.logger.info(msg)
    #TODO why we need synchrony here
    EM.synchrony {
      user = User.find(msg)
      RepoFetcher.new(user).each {|repo| env.stream_send(repo.to_json)}
    }
  end

  def on_error(env, error)
    env.logger.error(error)
  end

  def on_close(env)
    env.logger.info "CLOSED"
  end

end

class Websocket < Goliath::API
  map '/watched_repos', WebsocketEndPoint
end