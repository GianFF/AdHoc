module Generos
  class GeneroFemenino < ApplicationRecord
    def self.doctor_o_doctora
      'Dra.'
    end

    def self.inscripta_inscripto
      'inscripta'
    end

    def self.abogada_abogado
      'abogada'
    end

    def self.la_el
      'la'
    end

    def self.letrada_letrado
      'letrada'
    end

    def self.es(genero)
      genero == Generos::FEMENINO
    end
  end
end
