module Escritos
  class Notificacion < Escrito
    validates :fuero, :nombre, :calle, :nro, :piso, :localidad, :tipo_domicilio, :caracter,
              :observaciones, presence: { message: mensaje_de_error_para_campo_vacio }
  end
end
