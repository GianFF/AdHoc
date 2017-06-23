class ContestacionDeDemandasController < EscritosController
  def create
    super do
      @escrito = @ad_hoc.crear_nueva_contestacion_de_demanda!(validar_parametros_escrito, validar_parametros_expediente, abogado_actual)
    end
  end

  def presentar
    super do
      render :show
    end
  end

  def clonar
    super do
      render :show
    end
  end

  private

  def new_escrito_expediente_y_cliente
    super do
      @escrito = ContestacionDeDemanda.new
    end
  end

  def validar_parametros_escrito
    params.require(:contestacion_de_demanda).permit(:cuerpo, :titulo)
  end
end
