Rails.application.routes.draw do
  resources :ingredients do
    collection do
      post 'import'
    end
  end

  get '/shopping_list', to: 'shopping_lists#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
