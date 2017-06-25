class ContestacionDeDemanda < Escrito
  validates :cuerpo, presence: { message: mensaje_de_error_para_campo_vacio}

  def encabezado(abogado, expediente, cliente)
    self.encabezado = EncabezadoConDatosDelExpediente.value(abogado, expediente, cliente) unless @encabezado #TODO test: unless self.encabezado
  end

  def url
    'contestacion_de_demandas'
  end
end
