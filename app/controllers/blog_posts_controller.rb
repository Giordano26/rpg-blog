class BlogPostsController < ApplicationController
  def index
    @blog_posts = BlogPost.all
  end

  def show
    @blog_post = BlogPost.find_by_path(params[:year], params[:month], params[:day], params[:slug])
    redirect_to blog_posts_path, alert: "Post não encontrado" unless @blog_post
  end

  def download
    @blog_post = BlogPost.find_by_path(params[:year], params[:month], params[:day], params[:slug])
    return redirect_to blog_posts_path, alert: "Post não encontrado" unless @blog_post

    allowed_files = @blog_post.download_files
    requested_filename = params[:filename].to_s

    if requested_filename.blank? || requested_filename.include?("..") || requested_filename.include?("/")
      redirect_to blog_post_path(@blog_post), alert: "Nome de arquivo inválido"
      return
    end

    file_info = allowed_files.find { |f| f["filename"] == requested_filename }
    unless file_info
      redirect_to blog_post_path(@blog_post), alert: "Arquivo não encontrado"
      return
    end

    year_str = @blog_post.year.to_s
    month_str = @blog_post.month.to_s.rjust(2, "0")
    day_str = @blog_post.day.to_s.rjust(2, "0")
    slug_str = @blog_post.slug.to_s
    filename_str = file_info["filename"]

    file_path = Rails.root.join("public", "downloads", "posts", year_str, month_str, day_str, slug_str, filename_str)

    unless File.exist?(file_path) && file_path.to_s.include?("/public/downloads/posts/")
      redirect_to blog_post_path(@blog_post), alert: "Arquivo não encontrado"
      return
    end

    send_file file_path, disposition: "attachment", filename: filename_str
  end

  private

  def blog_post_path(blog_post)
    "/#{blog_post.year}/#{blog_post.month.to_s.rjust(2, '0')}/#{blog_post.day.to_s.rjust(2, '0')}/#{blog_post.slug}"
  end
end
