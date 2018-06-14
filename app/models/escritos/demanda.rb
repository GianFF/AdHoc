module Escritos
  class Demanda < Escrito
    def encabezado(abogado, expediente, cliente)
      self.encabezado = Encabezado.value(abogado, expediente, cliente) unless @encabezado #TODO test: unless self.encabezado
    end
  end
end
