class Demanda < Escrito
  validates :cuerpo, presence: { message: mensaje_de_error_para_campo_vacio}

  def encabezado(abogado, expediente, cliente)
    self.encabezado = Encabezado.value(abogado, expediente, cliente) unless @encabezado #TODO test: unless self.encabezado
  end

  def url
    'demandas'
  end
end
