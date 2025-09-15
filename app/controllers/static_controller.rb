class StaticController < ApplicationController
  def show
    if %w[about].include? params[:page]
      render params[:page]
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end
end
