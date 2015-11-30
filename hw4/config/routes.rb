Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => 'movies#index'
  resources :movies do
    get "/similar" => "movies#similar", :as => :similar
  end
end
