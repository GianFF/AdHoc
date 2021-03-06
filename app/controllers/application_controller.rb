class ApplicationController < ActionController::Base
  attr_reader :ad_hoc
  layout 'application'
  before_action :crear_aplicacion
  protect_from_forgery with: :exception

  rescue_from do
    #TODO: loggear
    flash.keep[:error] = ['Algo ha salido mal.. contacte con su administrador si el problema persiste']
    redirect_back(fallback_location: root_path)
  end
  rescue_from AdHocHackExcepcion do |excepcion|
    mostrar_errores(excepcion, mantener_error: true)
    redirect_back(fallback_location: root_path)
  end

  def abogado_actual
    current_abogado
  end

  def rescue_hack_exception(excepcion)
    mostrar_errores(excepcion, mantener_error: true)
    redirect_back(fallback_location: root_path)
  end

  def mostrar_errores(excepcion, mantener_error: false)
    errores = excepcion.errores
    flash.keep[:error] = errores and return if mantener_error
    flash.now[:error] = errores
  end

  private

  def crear_aplicacion
    @ad_hoc = AdHocAplicacion.new
  end
end
