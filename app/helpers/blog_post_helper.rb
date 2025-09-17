module BlogPostHelper
  def process_blog_content(content)
    erb_processed = ERB.new(content).result(binding)
    
    renderer = Redcarpet::Render::HTML.new(prettify: true)
    markdown = Redcarpet::Markdown.new(renderer, extensions = { fenced_code_blocks: true })
    markdown.render(erb_processed).html_safe
  end
end

