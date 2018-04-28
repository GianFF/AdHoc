class AdjuntosController < ApplicationController
  before_action :authenticate_abogado!

  def new
    @adjunto = Adjunto.new
    @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
    @cliente = @expediente.cliente
  end

  def show
    begin
      show_adjunto
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    begin
      create_adjunto

      render :show
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      render :new
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    begin
      update_adjunto

      render :show
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      render :show
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    begin
      adjunto = @ad_hoc.buscar_adjunto_por_id!(params[:id], validar_parametros_expediente, abogado_actual)
      adjunto.remove_archivo_adjunto!
      adjunto.destroy

      @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
      @cliente = @expediente.cliente

      redirect_to expediente_url(validar_parametros_expediente)
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def show_adjunto
    @adjunto = @ad_hoc.buscar_adjunto_por_id!(params[:id], validar_parametros_expediente, abogado_actual)
    cargar_expediente_y_cliente
  end

  def create_adjunto
    @adjunto = @ad_hoc.crear_nuevo_adjunto!(validar_parametros_adjunto, validar_parametros_expediente, abogado_actual)
    cargar_expediente_y_cliente
  end

  def update_adjunto
    @adjunto = @ad_hoc.editar_adjunto!(params[:id], validar_parametros_expediente, abogado_actual, validar_parametros_adjunto)
    cargar_expediente_y_cliente
  end

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
