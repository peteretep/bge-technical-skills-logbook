Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root "dashboard#index"

  post "dashboard/create_classroom", to: "dashboard#create", as: "create_classroom"

  resources :classrooms do
    resources :students, only: [ :create, :destroy ]
    member do
      post :bulk_mark_skills
      get :bulk_mark
      get :viable_badges
      post :award_viable_badge
      post :award_all_viable_badges
    end
  end

  # Students routes at top level (not nested)
  resources :students, only: [ :show, :update ] do
    member do
      post :award_badge
      patch :toggle_skill, to: "student_skills#toggle"
    end
  end

  resources :badges, only: [ :create ]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
