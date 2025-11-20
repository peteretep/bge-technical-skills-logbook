Rails.application.routes.draw do
  devise_for :users
  
  root "dashboard#index"
  post "dashboard/create_classroom", to: "dashboard#create", as: "create_classroom"
  
  resources :classrooms do
    resources :students, only: [:create, :destroy]
    member do
      post :bulk_mark_skills
    end
    
    resources :students, only: [:show, :update] do
      member do
        post :award_badge
      end
            resources :badges, only: [:create]
      member do
        patch 'student_skills/toggle', to: 'student_skills#toggle', as: 'toggle_skill'
      end
    end
    
    # resources :students, only: [] do
    #   resources :badges, only: [:create]
    #   member do
    #     patch 'student_skills/toggle', to: 'student_skills#toggle', as: 'toggle_skill'
    #   end
    # end
    
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    
    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check
    
    # Render dynamic PWA files from app/views/pwa/*
    get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
    get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  end
end
