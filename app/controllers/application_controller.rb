require_relative '../../app/aplications/ad_hoc_aplicacion'

class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery with: :exception

  attr_reader :ad_hoc

  before_action :crear_aplicacion

  private

  def crear_aplicacion
    @ad_hoc = AdHocAplicacion.new
  end
end
