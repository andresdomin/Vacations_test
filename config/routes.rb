Vacaciones::Application.routes.draw do

  devise_for :users, :controllers => { :sessions => "users/sessions" }
  
  match '/requests/leader_mail' => 'requests#leader_mail', :via => :post
  get '/requests/autocomplete'
  match '/requests/range_check' => 'requests#range_check', :via => :get
  resources :requests, :only => [:show, :index, :create, :new, :update]

  match '/holidays/calculate_days' => 'holidays#calculate_days', :via => :get
  resources :holidays
                          
  match '/admin' => 'admin#index', :via => :get
  match '/admin/upload' => 'admin#upload', :via => :post
  match '/admin/database' => 'admin#database', :via => :get
  match '/admin/save' => 'admin#save', :via => :post
  match '/vacations' => 'vacations#index', :via => :get

  #match '/admin/leaders_index' => 'admin#leaders_index', :via => :get
  match '/admin/show' => 'admin#show', :via => :post
  match '/admin/leaders' => 'admin#leaders', :via => :get
  match '/admin/save_leaders' => 'admin#save_leaders', :via => :post



  root :to => 'home#index'
end
