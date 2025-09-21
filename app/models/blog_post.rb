require "redcarpet"
require "yaml"
require "erb"

class BlogPost
  include ActiveModel::Model
  include ActiveModel::Attributes
  
  attribute :title, :string
  attribute :date, :datetime
  attribute :description, :string
  attribute :tags, :string
  attribute :categories, :string
  attribute :body, :string
  attribute :slug, :string
  attribute :year, :integer
  attribute :month, :integer
  attribute :day, :integer
  attribute :download_files, default: -> { [] }
  
  def self.all
    posts = []
    posts_path = Rails.root.join('app', 'posts')
    
    Dir.glob("#{posts_path}/**/*.md").sort.reverse.each do |file_path|
      relative_path = file_path.sub("#{posts_path}/", '')
      
      
      if match = relative_path.match(%r{^(\d{4})/(\d{2})/(\d{2})/(.+)\.md$})
        year, month, day, slug = match.captures
        
        content = File.read(file_path)
        frontmatter, body = parse_frontmatter(content)
        
        download_dir = Rails.root.join('public', 'downloads', 'posts', year, month, day, slug)
        download_files = []
        
        if Dir.exist?(download_dir)
          Dir.glob("#{download_dir}/*").each do |download_file|
            filename = File.basename(download_file)
            download_files << {
              'name' => filename.gsub(/\.[^.]+$/, '').humanize,
              'filename' => filename,
              'size' => File.size(download_file)
            }
          end
        end
        
        posts << new(
          title: frontmatter['title'],
          date: frontmatter['date'] || Date.new(year.to_i, month.to_i, day.to_i),
          description: frontmatter['description'],
          tags: frontmatter['tags'],
          categories: frontmatter['categories'],
          body: body,
          slug: slug,
          year: year.to_i,
          month: month.to_i,
          day: day.to_i,
          download_files: download_files
        )
      end
    end
    
    posts
  end
  
  def self.find(id)
    parts = id.split('-', 4)
    return nil unless parts.length >= 4
    
    year, month, day, slug = parts[0], parts[1], parts[2], parts[3]
    find_by_path(year, month, day, slug)
  end
  
  def self.find_by_path(year, month, day, slug)
    file_path = Rails.root.join('app', 'posts', year.to_s, 
                               month.to_s.rjust(2, '0'), 
                               day.to_s.rjust(2, '0'), 
                               "#{slug}.md")
    
    return nil unless File.exist?(file_path)
    
    content = File.read(file_path)
    frontmatter, body = parse_frontmatter(content)
    
    download_dir = Rails.root.join('public', 'downloads', 'posts', year, month, day, slug)
    download_files = []
    
    if Dir.exist?(download_dir)
      Dir.glob("#{download_dir}/*").each do |download_file|
        filename = File.basename(download_file)
        download_files << {
          'name' => filename.gsub(/\.[^.]+$/, '').humanize,
          'filename' => filename,
          'size' => File.size(download_file)
        }
      end
    end
    
    new(
      title: frontmatter['title'],
      date: frontmatter['date'] || Date.new(year.to_i, month.to_i, day.to_i),
      description: frontmatter['description'],
      tags: frontmatter['tags'],
      categories: frontmatter['categories'],
      body: body,
      slug: slug,
      year: year.to_i,
      month: month.to_i,
      day: day.to_i,
      download_files: download_files
    )
  end
  
  def id
    "#{year}-#{month.to_s.rjust(2, '0')}-#{day.to_s.rjust(2, '0')}-#{slug}"
  end
  
  def url_path
    "/#{year}/#{month.to_s.rjust(2, '0')}/#{day.to_s.rjust(2, '0')}/#{slug}"
  end
  
  def has_downloads?
    download_files.any?
  end
  
  def formatted_date
    Date.new(year, month, day)
  end
  
  private
  
  def self.parse_frontmatter(content)
    if content.start_with?('---')
      parts = content.split('---', 3)
      frontmatter = YAML.safe_load(parts[1]) || {}
      body = parts[2]&.strip || ''
    else
      frontmatter = {}
      body = content
    end
    
    [frontmatter, body]
  end
end
