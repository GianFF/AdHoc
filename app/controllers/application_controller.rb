require_relative '../../app/aplications/ad_hoc_aplicacion'
require_relative '../../app/errors/ad_hoc_excepcion'

class ApplicationController < ActionController::Base
  attr_reader :ad_hoc
  layout 'application'
  before_action :crear_aplicacion
  protect_from_forgery with: :exception

  def abogado_actual
    current_abogado
  end

  def rescue_hack_exception(excepcion)
    mostrar_errores(excepcion, mantener_error: true)
    redirect_back(fallback_location: root_path)
  end

  def mostrar_errores(excepcion, mantener_error: false)
    flash.keep[:error] = excepcion.errores and return if mantener_error
    flash.now[:error] = excepcion.errores
  end

  private

  def crear_aplicacion
    @ad_hoc = AdHocAplicacion.new
  end
end
