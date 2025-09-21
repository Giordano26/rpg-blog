module BlogPostsHelper
  def blog_post_path(post)
    dated_blog_post_path(
      year: post.year,
      month: post.month.to_s.rjust(2, "0"),
      day: post.day.to_s.rjust(2, "0"),
      slug: post.slug
    )
  end

  def blog_post_url(post)
    dated_blog_post_url(
      year: post.year,
      month: post.month.to_s.rjust(2, "0"),
      day: post.day.to_s.rjust(2, "0"),
      slug: post.slug
    )
  end

  def blog_post_download_path(post, filename)
    dated_blog_post_download_path(
      year: post.year,
      month: post.month.to_s.rjust(2, "0"),
      day: post.day.to_s.rjust(2, "0"),
      slug: post.slug,
      filename: filename
    )
  end

  def format_file_size(size)
    return "0 Bytes" if size == 0

    units = [ "Bytes", "KB", "MB", "GB" ]
    i = (Math.log(size) / Math.log(1024)).floor
    (size / 1024.0**i).round(2).to_s + " " + units[i]
  end
end
