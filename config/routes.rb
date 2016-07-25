Rails.application.routes.draw do
  resources :chirps
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'login' => 'users#login'
  get 'timeline' => 'chirps#timeline'
  get 'profile' => 'users#profile'
  get 'follow'  => 'users#followme'
  get 'unfollow' => 'users#unfollowme'
  get 'search' => 'users#search'



end
