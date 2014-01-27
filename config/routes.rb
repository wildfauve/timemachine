Timemachine::Application.routes.draw do
  
  root :to => "employees#index"
  
  get "sign_in" => 'users#new', as: "sign_in"
  
  resources :users
  
  resources :customers do
    resources :projects
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
      post 'projstate'
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
