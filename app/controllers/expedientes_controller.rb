class ExpedientesController < ApplicationController
  #TODO: before_action :authenticate_abogado!

  def show
    @cliente = @ad_hoc.buscar_expediente_por_id!(params[:id])
  end

  def create
    begin
      @expediente = @ad_hoc.crear_expediente_nuevo!(validar_parametros_expediente)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
      render :show
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @ad_hoc.mensaje_de_error_para_expediente_invalido
      render :new
    end
  end

  def validar_parametros_expediente
    params.require(:expediente).permit(:actor, :demandado, :materia, :cliente)
  end
end