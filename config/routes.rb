DeadchanNet::Application.routes.draw do
  root 'home#index'

  scope '/lodge' do
    devise_for :admins
  end

  devise_for :users

  namespace :lodge do
    get '/' => 'dashboard#index'

    resources :boards
    resources :treads do
      resources :posts, except: [:index, :show]
    end
    resources :users, only: [:index, :destroy]
    resources :bans, except: :show

    mount RailsSettingsUi::Engine, at: 'settings'
  end

  scope 'treads' do
    get '/form/:abbr/:id' => 'treads#form', as: :post_form
    get '/:id'            => 'posts#index'
  end

  scope 'boards' do
    get '/form/:abbr' => 'boards#form', as: :tread_form
  end

  scope ':abbr' do
    get   '/'     => 'boards#show', as: :board
    post  '/'     => 'boards#create'
    get   '/:id'  => 'treads#show', as: :tread
    post  '/:id'  => 'treads#create'
  end
end
