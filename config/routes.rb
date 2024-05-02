# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  draw :accounts
  draw :api
  draw :billing
  draw :turbo_native
  draw :users
  draw :dev if Rails.env.local?

  authenticated :user, lambda { |u| u.admin? } do
    draw :admin
  end

  resources :source_tokens do
    post "refresh_token", on: :member
  end

  post "/campaigns/:campaign_id/validate_formula", to: "calculated_fields#validate_formula"
  get "/posting_instructions/:token", to: "posting_instructions#show", as: :posting_instructions

  resources :campaigns do
    collection do
      get :field
    end
    member do
      get :logs
    end
    resources :sources do
      member do
        patch :archive
        patch :activate
        patch :pause
      end
    end
    resources :source_filters do
      member do
        patch :archive
        patch :activate
        patch :pause
      end
    end
    resources :distributions
    resources :distribution_filters do
      member do
        patch :archive
        patch :activate
        patch :pause
      end
    end
    resources :campaign_fields, path: :fields do
      member do
        patch :move
      end
      collection do
        get :list_value
      end
    end
    resources :calculated_fields do
      member do
        patch :archive
        patch :activate
        patch :pause
      end
    end
    resources :build, controller: "campaigns/build"
  end

  resources :distributions do
    resources :campaign_distributions, only: [:show, :edit, :update], path: :field_mappings

    collection do
      get :header
    end
  end

  resources :campaign_fields, path: :fields do
    resources :validations do
      collection do
        get :options
      end
    end
  end

  resources :verticals do
    collection do
      get :vertical_field
    end
    member do
      put "archive"
      put "unarchive"
    end
    resources :vertical_fields do
      member do
        patch :move
      end
      collection do
        get :list_value
      end
    end
  end

  resources :companies do
    resources :contacts
  end

  resources :sources, only: [:index]
  resources :campaign_distributions, only: [:destroy] do
    collection do
      get :mapped_field
    end
  end

  resources :announcements, only: [:index, :show]

  namespace :action_text do
    resources :embeds, only: [:create], constraints: {id: /[^\/]+/} do
      collection do
        get :patterns
      end
    end
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
    get :pricing
  end

  match "/404", via: :all, to: "errors#not_found"
  match "/500", via: :all, to: "errors#internal_server_error"

  authenticated :user do
    root to: "dashboard#show", as: :user_root
    # Alternate route to use if logged in users should still see public root
    # get "/dashboard", to: "dashboard#show", as: :user_root
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # Public marketing homepage
  root to: "static#index"
end
