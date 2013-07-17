Timemachine::Application.routes.draw do
  resources :customers do
    resources :projects
  end
  
  resources :employees
  
end
