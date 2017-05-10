class ExpedientesController < ApplicationController
  before_action :authenticate_abogado!

  def show
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:id])
    @cliente = @expediente.cliente
  end

  def new
    @expediente = Expediente.new
    @cliente = Cliente.find(params[:cliente_id])
    @expediente.cliente = @cliente
  end

  def create
    begin
      @expediente = @ad_hoc.crear_expediente_nuevo!(validar_parametros_expediente, validar_parametros_cliente)
      @cliente = @expediente.cliente
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_invalido
      render :new
    end
  end

  private

  def validar_parametros_expediente
    params.require(:expediente).permit(:actor, :demandado, :materia)
  end

  def validar_parametros_cliente
    params.require(:cliente_id)
  end
end