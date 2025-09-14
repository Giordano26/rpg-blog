class HomepageController < ApplicationController
  def index
    blogposts = BlogPost.all

    @grouped_blogposts = blogposts.group_by { |bp| bp.date.year }.transform_values do |blogposts_by_year|
      blogposts_by_year.group_by { |bp| I18n.l(bp.date, format: "%B") }
    end
  end
end
