Rails.application.routes.draw do
  root "homepage#index"
  get "/:page" => "static#show"

  resources :blog_posts, only: [ :show ], param: :id, path: "posts"
end
