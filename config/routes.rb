Timemachine::Application.routes.draw do
  resources :customers do
    resources :projects
  end
  
  resources :assignments
  
  resources :employees do
     member do
      post 'date'
      post 'erase'
    end
    resources :assignments do
      member do
       post 'date'
       post 'calc'
      end
    end      
  end
  
  resources :dashboards do
    collection do
      resources :by_employee do
        member do
          get 'date'
          post 'daterefresh'
        end
      end
    end
  end
  
end
