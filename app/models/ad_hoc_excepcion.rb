class AdHocExcepcion < Exception
  attr_reader :adhoc_error

  def initialize(adhoc_error)
    @adhoc_error = adhoc_error
  end
end
