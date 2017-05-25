class Escrito < ApplicationRecord
  belongs_to :expediente

  def titulo
    'Un escrito'
  end

  def pertenece_a?(un_abogado)
    self.expediente.pertenece_a? un_abogado
  end
end
