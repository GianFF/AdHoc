class AdHocExcepcion < Exception
  attr_reader :error

  def initialize(error_wrapper)
    @error = error_wrapper
  end
end
