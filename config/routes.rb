Rails.application.routes.draw do
  # Standard web routes for Devise (keeps /users/sign_in available)
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


  resources :students do
    member do
      delete :remove_profile_photo
      delete :remove_document
      post :generate_report
      get :download_report
    end
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
