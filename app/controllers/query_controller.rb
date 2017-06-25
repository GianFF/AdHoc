class QueryController  < ApplicationController
  before_action :authenticate_abogado!

  def buscar
    respond_to do |format|
      format.json { render json: @ad_hoc.buscar(validar_query, abogado_actual) }
    end
  end

  private

  def validar_query
    params.require(:query)
  end
end
