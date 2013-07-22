Timemachine::Application.routes.draw do
  resources :customers do
    resources :projects
  end
  
  resources :assignments
  
  resources :employees do
     member do
      post 'calc'
    end
    resources :assignments
  end
  
end
