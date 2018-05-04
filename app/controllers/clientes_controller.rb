class ClientesController < ApplicationController
  before_action :authenticate_abogado!
  attr_reader :cliente

  def index
    begin
      @cliente = ad_hoc.buscar_cliente_por_nombre_o_apellido!(params.require(:query), abogado_actual.id)
      inicializar_expedientes
      render :show
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      render :new
    end
  end

  def show
    @cliente = ad_hoc.buscar_cliente_por_id!(params[:id], abogado_actual.id)
    inicializar_expedientes
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    @cliente = ad_hoc.buscar_cliente_por_id!(cliente_id, abogado_actual.id)
  end

  def create
    begin
      @cliente = ad_hoc.crear_cliente_nuevo!(validar_parametros_cliente, abogado_actual)
      inicializar_expedientes
      flash.now[:success] = ad_hoc.mensaje_cliente_creado_correctamente
      render :show, status: :ok
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      render :new
    end
  end

  def update
    begin
      @cliente = ad_hoc.editar_cliente!(cliente_id, validar_parametros_cliente, abogado_actual)
      inicializar_expedientes
      flash.now[:success] = ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
      render :show
    rescue Errores::AdHocDomainError => excepcion
      mostrar_errores(excepcion)
      @cliente = ad_hoc.buscar_cliente_por_id!(cliente_id, abogado_actual.id)
      render :edit
    end
  end

  def destroy
    ad_hoc.eliminar_cliente!(params[:id], abogado_actual.id)
    flash.now[:success] = ad_hoc.mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
    @cliente = nil
    render :new
  end

  private

  def ad_hoc
    AdHocClientes.new
  end

  def inicializar_expedientes
    @expedientes = @cliente.expedientes
  end

  def validar_parametros_cliente
    params.require(:cliente).permit(:nombre, :apellido, :correo_electronico, :telefono,
                                    :estado_civil, :empresa, :trabaja_en_blanco)
  end

  # TODO: eliminar cuanto antes este parche.
  # Entender porque en el form de edicion viene el ID del cliente como format en vez de como id
  def cliente_id
    params[:format] || params[:id]
  end
end
