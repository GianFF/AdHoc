class ExpedientesController < ApplicationController
  before_action :authenticate_abogado!

  def show
    buscar_expediente_y_cliente
  end

  def new
    @expediente = Expediente.new
    @cliente = @ad_hoc.buscar_cliente_por_id(validar_parametros_cliente)
    @expediente.cliente = @cliente
  end

  def edit
    buscar_expediente_y_cliente
  end

  def create
    begin
      @expediente = @ad_hoc.crear_expediente_nuevo!(validar_parametros_expediente, validar_parametros_cliente)
      @cliente = @expediente.cliente
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_invalido
      @expediente = Expediente.new
      @cliente = @ad_hoc.buscar_cliente_por_id(validar_parametros_cliente)
      render :new
    end
  end

  def update
    begin
      @expediente = @ad_hoc.editar_expediente!(params[:id], validar_parametros_expediente)
      @cliente = @ad_hoc.buscar_cliente_por_id(validar_parametros_cliente)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_invalido
      buscar_expediente_y_cliente
      render :edit, status: :bad_request
    end
  end

  def destroy
    #TODO
  end

  private

  def buscar_expediente_y_cliente
    @expediente = @ad_hoc.buscar_expediente_por_id(params[:id])
    @cliente = @expediente.cliente
  end

  def validar_parametros_expediente
    params.require(:expediente).permit(:actor, :demandado, :materia)
  end

  def validar_parametros_cliente
    params.require(:cliente_id)
  end
end