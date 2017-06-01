class ClientesController < ApplicationController
  before_action :authenticate_abogado!
  attr_reader :cliente

  def index
    begin
      @cliente = @ad_hoc.buscar_cliente_por_nombre_o_apellido!(validar_parametro_query, abogado_actual.id)
      @expedientes = @cliente.expedientes
      render :show
    rescue UIExcepcion => excepcion
      mostrar_errores(excepcion)
      render :new
    end
  end

  def show
    begin
      @cliente = @ad_hoc.buscar_cliente_por_id!(params[:id], abogado_actual.id)
      @expedientes = @cliente.expedientes
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    begin
      @cliente = @ad_hoc.buscar_cliente_por_id!(cliente_id, abogado_actual.id)
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def create
    begin
      @cliente = @ad_hoc.crear_cliente_nuevo!(validar_parametros_cliente, abogado_actual)
      @expedientes = @cliente.expedientes
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente
      render :show
    rescue UIExcepcion => excepcion
      mostrar_errores(excepcion)
      @cliente = nil
      render :new
    end
  end

  def update
    begin
      @cliente = @ad_hoc.editar_cliente!(cliente_id, validar_parametros_cliente, abogado_actual)
      @expedientes = @cliente.expedientes
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
      render :show
    rescue UIExcepcion => excepcion
      mostrar_errores(excepcion)
      @cliente = @ad_hoc.buscar_cliente_por_id!(cliente_id, abogado_actual.id)
      render :edit
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def destroy
    begin
      @ad_hoc.eliminar_cliente!(params[:id], abogado_actual.id)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
      @cliente = nil
      render :new
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  private

  def validar_parametro_query
    params.require(:query)
  end

  def validar_parametros_cliente
    params.require(:cliente).permit(:nombre, :apellido, :correo_electronico, :telefono,
                                    :estado_civil, :empresa, :esta_en_blanco)
  end

  # TODO: eliminar cuanto antes este parche.
  # Entender porque en el form de edicion viene el ID del cliente como format en vez de como id
  def cliente_id
    params[:format] || params[:id]
  end
end
