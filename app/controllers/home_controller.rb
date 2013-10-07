class HomeController < ApplicationController
  def index
  end

  def set_locale
  	session[:locale] = params["locale"].try(:to_sym) || :en
  	redirect_to :back
  end
end
