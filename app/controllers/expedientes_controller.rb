class ExpedientesController < ApplicationController
  before_action :authenticate_abogado!

  def show
    begin
      buscar_expediente_y_cliente
    rescue ActiveRecord::RecordNotFound
      flash.keep[:error] = @ad_hoc.mensaje_de_error_para_expediente_inexistente
      redirect_back(fallback_location: root_path)
    end
  end

  def new
    @expediente = Expediente.new
    @cliente = @ad_hoc.buscar_cliente_por_id!(validar_parametros_cliente, abogado_actual)
    @expediente.cliente = @cliente
  end

  def edit
    begin
      buscar_expediente_y_cliente
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_inexistente
    end
  end

  def create
    begin
      @expediente = @ad_hoc.crear_expediente_nuevo!(validar_parametros_expediente, validar_parametros_cliente, abogado_actual)
      @cliente = @expediente.cliente
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_invalido
      @expediente = Expediente.new
      @cliente = @ad_hoc.buscar_cliente_por_id!(validar_parametros_cliente, abogado_actual)
      render :new
    end
  end

  def update
    begin
      @expediente = @ad_hoc.editar_expediente!(params[:id], validar_parametros_expediente, abogado_actual)
      @cliente = @ad_hoc.buscar_cliente_por_id!(validar_parametros_cliente, abogado_actual)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_invalido
      buscar_expediente_y_cliente
      render :edit, status: :bad_request
    rescue ActiveRecord::RecordNotFound
      flash.keep[:error] = @ad_hoc.mensaje_de_error_para_expediente_inexistente
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    begin
      @ad_hoc.eliminar_expediente!(params[:id], abogado_actual)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente
    rescue ActiveRecord::RecordNotFound
      flash.keep[:error] = @ad_hoc.mensaje_de_error_para_expediente_inexistente
    end
    redirect_to cliente_url(validar_parametros_cliente)
  end

  def numerar
    begin
      buscar_expediente_y_cliente
      if @expediente.ha_sido_numerado?
        flash.keep[:error] = @expediente.mensaje_de_error_para_expediente_numerado
        redirect_back(fallback_location: root_path) and return
      end
    rescue ActiveRecord::RecordNotFound
      flash.keep[:error] = @ad_hoc.mensaje_de_error_para_expediente_inexistente
      redirect_back(fallback_location: root_path)
    end
  end

  def realizar_numeraracion
    begin
      @expediente = @ad_hoc.numerar_expediente!(validar_parametros_para_numerar_expediente, params[:id], abogado_actual)
      @cliente = @expediente.cliente
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_numeracion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_inexistente
    end
  end

  private

  def buscar_expediente_y_cliente
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:id], abogado_actual)
    @cliente = @expediente.cliente
  end

  def validar_parametros_expediente
    params.require(:expediente).permit(:actor, :demandado, :materia)
  end

  def validar_parametros_cliente
    params.require(:cliente_id)
  end

  def validar_parametros_para_numerar_expediente
    params.require(:expediente).permit(:id, :numero, :juzgado, :numero_de_juzgado, :departamento,
                                       :ubicacion_del_departamento, :cliente_id)
  end
end
