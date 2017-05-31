require_relative '../../app/aplications/ad_hoc_aplicacion'

class ApplicationController < ActionController::Base
  layout 'application'
  protect_from_forgery with: :exception

  attr_reader :ad_hoc

  before_action :crear_aplicacion

  def abogado_actual
    current_abogado
  end

  def mostrar_errores(excepcion, with_keep: false)
    adhoc_error = excepcion.adhoc_error
    mostrar_mensaje_de_error(adhoc_error) and return if with_keep
    mantener_mensaje_de_error(adhoc_error)
  end

  private

  def mantener_mensaje_de_error(adhoc_error)
    if hay_un_solo_error?(adhoc_error)
      flash.now[:error] = obtener_error(adhoc_error)
    else
      flash.now[:error] = obtener_lista_de_errores(adhoc_error)
    end
  end

  def mostrar_mensaje_de_error(adhoc_error)
    if hay_un_solo_error?(adhoc_error)
      flash.keep[:error] = obtener_error(adhoc_error)
    else
      flash.keep[:error] = obtener_lista_de_errores(adhoc_error)
    end
  end

  def hay_un_solo_error?(adhoc_error)
    adhoc_error.errores.count == 1
  end

  def obtener_lista_de_errores(adhoc_error)
    adhoc_error.errores.map { |mensaje| "<li>#{mensaje}</li>" }.join
  end

  def obtener_error(adhoc_error)
    adhoc_error.errores.first
  end

  def crear_aplicacion
    @ad_hoc = AdHocAplicacion.new
  end
end
