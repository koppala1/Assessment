Rails.application.routes.draw do
  # ... (other routes)
  root 'tasks#home'
 get 'tasks/home', to: 'tasks#home', as: :home
  post 'tasks/create', to: 'tasks#create', as: :create_task
  get 'tasks/task_list', to: 'tasks#task_list', as: :task_list
  get 'tasks/edit/:id', to: 'tasks#edit', as: :edit_task
  patch 'tasks/update/:id', to: 'tasks#update_task', as: :update_task
  resources :tasks, except: [:show]
  delete 'tasks/delete_task/:id', to: 'tasks#delete_task', as: :delete_task
end

