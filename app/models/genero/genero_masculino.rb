module Genero
  class GeneroMasculino < ApplicationRecord
    def self.doctor_o_doctora
      'Dr.'
    end

    def self.inscripta_inscripto
      'inscripto'
    end

    def self.abogada_abogado
      'abogado'
    end

    def self.la_el
      'el'
    end

    def self.letrada_letrado
      'letrado'
    end

    def self.es(sexo)
      sexo == Genero::GeneroMasculino
    end
  end
end
