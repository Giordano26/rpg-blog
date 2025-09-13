Rails.application.routes.draw do

  root 'home_page#index'

  resources :blog_posts, only: [:show], param: :id

end
