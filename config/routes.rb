Rails.application.routes.draw do
  # Standard web routes for Devise (keeps /users/sign_in available)
  devise_for :users

  # Web UI resources
  resources :students

  # Root route for the web UI
  root "dashboard#index"

  # Dashboard pages (web UI)
  get 'dashboard/admin', to: 'dashboard#admin', as: 'admin_dashboard'
  get 'dashboard/teacher', to: 'dashboard#teacher', as: 'teacher_dashboard'
  get 'dashboard/teachers', to: 'dashboard#teachers', as: 'teachers_dashboard'
  get 'dashboard/home', to: 'dashboard#home', as: 'home_dashboard'
  # Backwards-compatible admin teachers path used by navigation
  get 'admin/teachers', to: 'dashboard#teachers', as: 'admin_teachers'

  # API login/logout mapped to Api::SessionsController
  devise_scope :user do
    post 'api/login', to: 'api/sessions#create', defaults: { format: :json }
    delete 'api/logout', to: 'api/sessions#destroy', defaults: { format: :json }
  end

  namespace :api, defaults: { format: :json } do
    resources :students

    resources :teachers do
      resources :students,
                controller: 'teacher_students',
                only: [:index, :create]
    end
  end
end