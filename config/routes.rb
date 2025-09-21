# config/routes.rb
Rails.application.routes.draw do
  root 'homepage#index'
  
  resources :blog_posts, only: [:index, :show] do
    member do
      get 'download/:filename', to: 'blog_posts#download', as: :download, constraints: { filename: /.*/ }
    end
  end
  
  get ':year/:month/:day/:slug', to: 'blog_posts#show', 
      constraints: { 
        year: /\d{4}/, 
        month: /\d{2}/, 
        day: /\d{2}/ 
      }, 
      as: :dated_blog_post
      
  get ':year/:month/:day/:slug/download/:filename', to: 'blog_posts#download',
      constraints: { 
        year: /\d{4}/, 
        month: /\d{2}/, 
        day: /\d{2}/,
        filename: /.*/
      }, 
      as: :dated_blog_post_download
  
  get 'sobre', to: 'static#about'
end

