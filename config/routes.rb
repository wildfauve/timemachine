Timemachine::Application.routes.draw do
  resources :customers do
    resources :projects
  end
  
  resources :assignments
  
  resources :employees do
     member do
      post 'calc'
      post 'date'
      post 'erase'
    end
    resources :assignments do
      member do
       post 'date'
      end
    end      
  end
  
  resources :dashboards do
    collection do
      resources :by_employee, :only => [:show]
    end
  end
  
end
