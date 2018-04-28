module Genero
  class Genero
    MASCULINO = 'Masculino'
    FEMENINO  = 'Femenino'

    def self.para(genero)
      return GeneroMasculino if genero == MASCULINO
      GeneroFemenino if genero == FEMENINO
    end

    def self.generos
      [MASCULINO, FEMENINO]
    end

    def self.es_valido(genero)
      generos.include?(genero)
    end

    def self.doctor_o_doctora
      raise Exception, 'Must be implemented'
    end

    def self.inscripta_inscripto
      raise Exception, 'Must be implemented'
    end

    def self.abogada_abogado
      raise Exception, 'Must be implemented'
    end

    def self.la_el
      raise Exception, 'Must be implemented'
    end

    def self.letrada_letrado
      raise Exception, 'Must be implemented'
    end

    def self.es _
      raise Exception, 'Must be implemented'
    end
  end
end
