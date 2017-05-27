class Escrito < ApplicationRecord
  belongs_to :expediente

  def pertenece_a?(un_abogado)
    self.expediente.pertenece_a? un_abogado
  end
end
