class EscritosController < ApplicationController
  attr_reader :escrito

  def new
    @escrito = Escrito.new
    @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
    @cliente = @expediente.cliente
  end

  def show
    @escrito = @ad_hoc.buscar_escrito_por_id!(params[:id])
    @expediente = @escrito.expediente
    @cliente = @expediente.cliente
  end

  def create
    @escrito = @ad_hoc.crear_escrito_nuevo!(validar_parametros_escrito, validar_parametros_expediente, abogado_actual)
    @expediente = @escrito.expediente
    @cliente = @expediente.cliente
    flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_escrito
    render :show
  end

  private

  def validar_parametros_escrito
    params.require(:escrito).permit(:cuerpo)
  end

  def validar_parametros_expediente
    params.require(:expediente_id)
  end
end
