class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.all
  end
  
  def show
    @blog_post = BlogPost.find_by_path(params[:year], params[:month], params[:day], params[:slug])
    
    redirect_to blog_posts_path, alert: 'Post não encontrado' unless @blog_post
  end
  
  def download
    @blog_post = BlogPost.find_by_path(params[:year], params[:month], params[:day], params[:slug])
    
    return redirect_to blog_posts_path, alert: 'Post não encontrado' unless @blog_post
    
    filename = params[:filename]
    file_path = Rails.root.join('public', 'downloads', 'posts', 
                               @blog_post.year.to_s, 
                               @blog_post.month.to_s.rjust(2, '0'),
                               @blog_post.day.to_s.rjust(2, '0'),
                               @blog_post.slug,
                               filename)
    
    if File.exist?(file_path)
      send_file file_path, disposition: 'attachment'
    else
      redirect_to @blog_post, alert: 'Arquivo não encontrado'
    end
  end
end

