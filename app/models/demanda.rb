class Demanda < Escrito
  validates :cuerpo, presence: { message: mensaje_de_error_para_campo_vacio}
end
