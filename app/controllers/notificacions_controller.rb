class NotificacionsController < EscritosController
  def create
    super do
      @escrito = @ad_hoc.crear_nueva_notificacion!(validar_parametros_escrito, validar_parametros_expediente, abogado_actual)
    end
  end

  private

  def new_escrito_expediente_y_cliente
    super do
      @escrito = Notificacion.new
    end
  end

  def validar_parametros_escrito
    params.require(:notificacion).permit(:fuero, :fecha_recepcion, :organo, :nombre, :calle, :nro, :piso, :localidad, :tipo_domicilio, :caracter, :observaciones, :titulo)
  end
end
