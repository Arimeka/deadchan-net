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
      resources :posts, only: [:update, :destroy]
    end
    resources :users
  end

  scope 'treads' do
    get '/form/:abbr/:id' => 'treads#form'
    get '/:id'            => 'posts#index'
  end

  scope 'boards' do
    get '/form/:abbr' => 'boards#form'
  end

  scope ':abbr' do
    get   '/'     => 'boards#show', as: :board
    post  '/'     => 'boards#create'
    get   '/:id'  => 'treads#show', as: :tread
    post  '/:id'  => 'treads#create'
  end
end
