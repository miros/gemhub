Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '1fe42473daec79482f13', 'ea4afb665578bc9e033927425953f8ed8d194668'
end
