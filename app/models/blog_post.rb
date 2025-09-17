require "redcarpet"
require "yaml"
require "erb"

class BlogPost
  include ActionView::Helpers::AssetUrlHelper

  attr_reader :id, :title, :date, :draft, :description, :tags, :categories, :content

  def initialize(file_path)
    @id = File.basename(file_path, ".md")

    raw_content = File.read(file_path)

    header_regex = /^---\s*\n(.*?)\n^---\s*\n/m
    match = raw_content.match(header_regex)

    if match
      header = YAML.safe_load(match[1], permitted_classes: [ Time ])
      @title = header["title"]
      @date = Time.parse(header["date"].to_s)
      @draft = header["draft"] || false
      @description = header["description"]
      @tags = header["tags"] || []
      @categories = header["categories"] || []
      @content = raw_content.sub(header_regex, "")
    else
      @title = "Titulo não encontrado"
      @date = File.mtime(file_path)
      @draft = true
      @content = raw_content
      @tags = []
      @categories = []
    end
  end

  def html_content
    renderer = Redcarpet::Render::HTML.new(prettify: true)
    markdown = Redcarpet::Markdown.new(renderer, extensions = { fenced_code_blocks: true })
    markdown.render(content).html_safe
  end

  def raw_content
    @content
  end

  def to_param
    id
  end

  def self.find(id)
    file_path = Rails.root.join("app", "posts", "#{id}.md")
    raise ActiveRecord::RecordNotFound unless File.exist?(file_path)
    new(file_path)
  end

  def self.all
    posts_path = Rails.root.join("app", "posts")
    Dir.glob("#{posts_path}/*.md").map do |file_path|
      new(file_path)
    end.reject(&:draft)
       .sort_by(&:date)
       .reverse
  end
end
