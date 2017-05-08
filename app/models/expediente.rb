class Expediente < ApplicationRecord
  belongs_to :cliente

  validates :actor, :demandado, :materia,  presence: true
end
