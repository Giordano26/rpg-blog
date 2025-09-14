Rails.application.routes.draw do
  root "homepage#index"

  resources :blog_posts, only: [ :show ], param: :id, path: "posts"
end
