class AdjuntosController < ApplicationController
  before_action :authenticate_abogado!

  def new
    @adjunto = Adjunto.new
    @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
    @cliente = @expediente.cliente
  end

  def show
    @adjunto = @ad_hoc.buscar_adjunto_por_id!(params[:id], validar_parametros_expediente, abogado_actual)
    cargar_expediente_y_cliente
  end

  def create
    begin
      @adjunto = @ad_hoc.crear_nuevo_adjunto!(validar_parametros_adjunto, validar_parametros_expediente, abogado_actual)
      cargar_expediente_y_cliente

      render :show
    rescue AdHocUIExcepcion => excepcion
      mostrar_errores(excepcion)
      @adjunto = Adjunto.new
      @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
      @cliente = @expediente.cliente

      render :new
    end
  end

  def update
    begin
      @adjunto = @ad_hoc.editar_adjunto!(params[:id], validar_parametros_expediente, abogado_actual, validar_parametros_adjunto)
      cargar_expediente_y_cliente

      render :show
    rescue AdHocUIExcepcion => excepcion
      mostrar_errores(excepcion)
      @adjunto = @ad_hoc.buscar_adjunto_por_id!(params[:id], validar_parametros_expediente, abogado_actual)
      @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
      @cliente = @expediente.cliente

      render :show
    end
  end

  def destroy
    adjunto = @ad_hoc.buscar_adjunto_por_id!(params[:id], validar_parametros_expediente, abogado_actual)
    adjunto.remove_archivo_adjunto!
    adjunto.destroy

    @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
    @cliente = @expediente.cliente

    redirect_to expediente_url(validar_parametros_expediente)
  end

  private

  def cargar_expediente_y_cliente
    @expediente = @adjunto.expediente
    @cliente = @expediente.cliente
  end

  def validar_parametros_adjunto
    params.require(:adjunto).permit(:titulo, :archivo_adjunto)
  end

  def validar_parametros_expediente
    params[:expediente_id]
  end
end
