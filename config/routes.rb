Gemhub::Application.routes.draw do

  root :to => redirect("/auth/github/")

  match '/auth/:provider/callback', :to => 'sessions#create'

  resources :watched_repos, :only => [:index]

end
