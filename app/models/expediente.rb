class Expediente < ApplicationRecord
  belongs_to :cliente
  belongs_to :abogado # TODO: revisar esta asociacion...

  validates :actor, :demandado, :materia, :cliente_id, :abogado_id, presence: true

  def pertenece_a?(un_abogado)
    self.abogado.tu_email_es?(un_abogado.email)
  end
end
