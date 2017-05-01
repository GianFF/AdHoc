class EstadoCivil
  SOLTERO    = 'Soltero/a'
  CASADO     = 'Casado/a'
  VIUDO      = 'Viudo/a'
  DIVORCIADO = 'Divorciado/a'

  def self.estados
    ['Elegir', SOLTERO, CASADO, VIUDO, DIVORCIADO]
  end
end
