Rails.application.routes.draw do
  devise_for :users

  get "admin_dashboard",
      to: "dashboard#admin"

  get "admin/teachers",
      to: "dashboard#teachers",
      as: :admin_teachers

  get "teacher_dashboard",
      to: "dashboard#teacher"

  get "up" => "rails/health#show",
      as: :rails_health_check

  root "dashboard#home"

  # Web Routes
  resources :students do
    member do
      delete :remove_profile_photo
      delete :remove_document
    end
  end

  # API Routes
  namespace :api, defaults: { format: :json } do
    post :login, to: "sessions#create"

    resources :teachers do
      resources :students, only: [:index, :create]
    end

    resources :students
  end
end