namespace :api, defaults: {format: :json} do
  namespace :v1 do
    resource :auth
    resource :me, controller: :me
    resource :password

    resources :accounts do
      resources :campaigns, only: [] do
        resources :sources, only: [] do
          post :ping, on: :member
          post :post, on: :member
        end
      end

      # resources :campaigns do
      #   resources :leads, only: [:create] do
      #     post 'ping', on: :member, to: 'leads#ping'
      #   end
      # end
    end
    resources :users
    resources :notification_tokens, param: :token, only: [:create, :destroy]
  end
end

resources :api_tokens
