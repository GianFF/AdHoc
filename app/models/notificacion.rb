class Notificacion < Escrito
  validates :fuero, :nombre, :calle, :nro, :localidad, :tipo_domicilio, :caracter, presence: { message: mensaje_de_error_para_campo_vacio }
end
