require_relative '../../app/aplications/ad_hoc_aplicacion'

class ApplicationController < ActionController::Base
  layout 'application'
  protect_from_forgery with: :exception

  attr_reader :ad_hoc

  before_action :crear_aplicacion

  def abogado_actual
    current_abogado
  end

  def mostrar_errores(adhoc_error)
    if adhoc_error.errores.count == 1
      flash.keep[:error] = adhoc_error.errores.first
    else
      flash.now[:error] = adhoc_error.errores.map { |mensaje| "<li>#{mensaje}</li>" }.join.html_safe
    end
  end

  private

  def crear_aplicacion
    @ad_hoc = AdHocAplicacion.new
  end
end
