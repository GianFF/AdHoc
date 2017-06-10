class AdjuntosController < ApplicationController
  before_action :authenticate_abogado!

  def new
    @adjunto = Adjunto.new
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:expediente_id], abogado_actual)
    @cliente = @expediente.cliente
  end

  def show
    @adjunto = Adjunto.find_by!({id: params[:id], expediente_id: params[:expediente_id]})
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:expediente_id], abogado_actual)
    @cliente = @expediente.cliente
  end

  def create
    adjunto = Adjunto.new(validar_parametros_adjunto)
    adjunto.expediente = Expediente.find(params[:expediente_id])
    adjunto.save!
    @adjunto = adjunto
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:expediente_id], abogado_actual)
    @cliente = @expediente.cliente
    render :show
  end

  def update
    adjunto = Adjunto.find_by!({id: params[:id], expediente_id: params[:expediente_id]})
    adjunto.update!(validar_parametros_adjunto)

    @adjunto = adjunto
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:expediente_id], abogado_actual)
    @cliente = @expediente.cliente

    render :show
  end

  def destroy
    adjunto = Adjunto.find_by!({id: params[:id], expediente_id: params[:expediente_id]})
    adjunto.destroy

    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:expediente_id], abogado_actual)
    @cliente = @expediente.cliente

    redirect_to expediente_url(params[:expediente_id])
  end

  private

  def validar_parametros_adjunto
    params.require(:adjunto).permit(:titulo, :archivo_adjunto)
  end
end
