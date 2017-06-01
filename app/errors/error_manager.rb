class ErrorManager
  def self.raise_ui_error(errors)
    error_wrapper = MessageErrorWrapper.new(errors)
    raise UIExcepcion.new(error_wrapper)
  end

  def self.raise_hack_error(errors)
    error_wrapper = MessageErrorWrapper.new(errors)
    raise HackExcepcion.new(error_wrapper)
  end

  def self.format_errors(excepcion)
    error_wrapper = excepcion.error_wrapper
    return error(error_wrapper) if there_is_only_one_error?(error_wrapper)
    error_list(error_wrapper)
  end

  private

  def self.there_is_only_one_error?(error_wrapper)
    error_wrapper.errors.count == 1
  end

  def self.error_list(error_wrapper)
    error_wrapper.errors.map { |message| "<li>#{message}</li>" }.join
  end

  def self.error(error_wrapper)
    error_wrapper.errors.first
  end
end

### Otra implementacion posible seria:
#
# class AdHocError
#
#   def self.call(errores, ui: false, hack: false)
#     adhoc_error = AdHocError.new(errores)
#     raise AdHocUIExcepcion.new(adhoc_error) if ui
#     raise AdHocHackExcepcion.new(adhoc_error) if hack
#   end
# end
#
