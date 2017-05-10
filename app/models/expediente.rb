class Expediente < ApplicationRecord
  belongs_to :cliente

  validates :actor, :demandado, :materia, :cliente_id, presence: true

  def titulo
    "#{self.actor} c/ #{self.demandado}"
  end

  def pertenece_a?(un_abogado)
    self.cliente.pertenece_a?(un_abogado)
  end
end
