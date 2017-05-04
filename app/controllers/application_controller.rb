require_relative '../../app/ad_hoc_aplicacion'

class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery with: :exception
end
