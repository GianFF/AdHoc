class ClientesController < ApplicationController
  before_action :authenticate_abogado!
  attr_reader :cliente

  def index
    begin
      @cliente = @ad_hoc.buscar_cliente_por_nombre_o_apellido!(validar_parametro_query, current_abogado.id)
      #@expedientes = @cliente.expedientes
      render :show
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_busqueda_de_cliente_fallida(params[:query])
      render :new
    end
  end

  def show
    begin
      @cliente = @ad_hoc.buscar_cliente_por_id!(params[:id], current_abogado.id)
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_cliente_inexistente
      render :new
    end
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    begin
      @cliente = @ad_hoc.buscar_cliente_por_id!(cliente_id, current_abogado.id)
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_cliente_inexistente
    end
  end

  def create
    begin
      @cliente = @ad_hoc.crear_cliente_nuevo!(validar_parametros_cliente, current_abogado)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente
      render :show
    rescue  ActiveRecord::RecordInvalid
      @cliente = nil
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_nombre_y_apellido_vacios
      render :new
    end
  end

  def update
    @cliente = @ad_hoc.buscar_cliente_por_id(cliente_id)
    begin
      @ad_hoc.editar_cliente!(@cliente, validar_parametros_cliente)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
      render :show
    rescue ActiveRecord::ActiveRecordError
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_nombre_y_apellido_vacios
      redirect_to action: :edit, status: :bad_request
    end
  end

  def destroy
    begin
      @ad_hoc.eliminar_cliente!(params[:id], current_abogado.id)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
      @cliente = nil
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_cliente_inexistente
    end
    render :new
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
