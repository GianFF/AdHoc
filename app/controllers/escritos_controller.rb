class EscritosController < ApplicationController
  before_action :authenticate_abogado!
  attr_reader :escrito

  def show
    begin
      show_escrito_expediente_y_cliente
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
  end

  def new
    new_escrito_expediente_y_cliente
  end

  def create
    begin
      yield
      buscar_expediente_y_cliente_para_escrito
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_escrito
      render :show
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      new_escrito_expediente_y_cliente
      render :new
    end
  end

  def update
    begin
      @escrito = @ad_hoc.editar_escrito!(params[:id], validar_parametros_escrito, abogado_actual)
      buscar_expediente_y_cliente_para_escrito
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_escrito
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      show_escrito_expediente_y_cliente
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
    render :show
  end

  def destroy
    begin
      @ad_hoc.eliminar_escrito!(params[:id], abogado_actual)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_escrito
      redirect_to expediente_url(validar_parametros_expediente)
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end
  end

  def presentar
    begin
      @escrito = @ad_hoc.presentar_escrito!(params[:id], abogado_actual)
      buscar_expediente_y_cliente_para_escrito
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_presentacion_de_un_escrito
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      show_escrito_expediente_y_cliente
    rescue Errores::AdHocHackExcepcion => excepcion
      mostrar_errores(excepcion, mantener_error: true)
      redirect_back(fallback_location: root_path)
    end

    render :show
  end

  private

  def new_escrito_expediente_y_cliente
    @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
    @cliente = @expediente.cliente
    yield
  end

  def show_escrito_expediente_y_cliente
    @escrito = @ad_hoc.buscar_escrito_por_id!(params[:id], abogado_actual)
    buscar_expediente_y_cliente_para_escrito
  end

  def buscar_expediente_y_cliente_para_escrito
    @expediente = @escrito.expediente
    @cliente = @expediente.cliente
  end

  def validar_parametros_expediente
    params.require(:expediente_id)
  end

  def validar_parametros_escrito
    raise Exception, 'Subclass Responsibility'
  end
end
