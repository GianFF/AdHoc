module Escritos
  class MeroTramite < Escrito
    def encabezado(abogado, expediente, cliente)
      self.encabezado = EncabezadoConDatosDelExpediente.value(abogado, expediente, cliente) unless @encabezado #TODO test: unless self.encabezado
    end
  end
end
