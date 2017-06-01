class AdHocExcepcion < Exception
  attr_reader :errores

  def initialize(errores)
    @errores = errores
  end
end
