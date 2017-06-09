class MeroTramitesController < EscritosController
  def create
    super do
      @escrito = @ad_hoc.crear_nuevo_mero_tramite!(validar_parametros_escrito, validar_parametros_expediente, abogado_actual)
    end
  end

  private

  def new_escrito_expediente_y_cliente
    super do
      @escrito = MeroTramite.new
    end
  end

  def validar_parametros_escrito
    params.require(:mero_tramite).permit(:cuerpo, :titulo)
  end
end
