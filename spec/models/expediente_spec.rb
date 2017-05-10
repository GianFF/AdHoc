require 'rails_helper'

describe Expediente, type: :model do

  it "tiene un titulo" do
    expediente = Expediente.new(actor: "Juan Pepe", demandado: "Maria Perez", materia: "Daños y Perjuicios")

    expect(expediente.titulo).to eq "#{expediente.actor} c/ #{expediente.demandado}"
  end
end
