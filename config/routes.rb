Timemachine::Application.routes.draw do
  
  root :to => "home#show"
  
  #root :to => "sessions#new"
  
  get "sign_in" => 'users#new', as: "sign_in"
  
  get "log_in" => 'sessions#new', as: 'log_in' 
  
  get "log_out" => 'sessions#destroy', as: 'log_out' 
  
  resources :admins
  
  resources :users
  
  resources :sessions
  
  resources :customers do
    resources :projects do
      resources :costcodes
    end
    member do
      get 'invoice'
      get 'export'
    end
  end
  
  resources :assignments
  
  resources :employees do
     member do
      post 'date'
      post 'erase'
      put 'projstate'
      get 'project'
      get 'assignments'
    end
    resources :assignments do
      member do
       post 'date'
       post 'calc'
       get 'time_change'
      end
    end      
  end
  
  resources :dashboards do
    collection do
      resources :by_employee do
        member do
          get 'date'
          post 'daterefresh'
          get 'totals'
          post 'calc_totals'
          get 'summary'
        end
      end
    end
  end
  
end
