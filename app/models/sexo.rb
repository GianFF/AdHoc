class Sexo
  #TODO: si el sexo fuera un objeto del lado del abogado, se podría reificar este if. Seguramente se neceisten
  # dos clases hijas, Masculino y Femenino.
  MASCULINO = 'Masculino'
  FEMENINO  = 'Femenino'

  def self.sexos
    [MASCULINO, FEMENINO]
  end

  def self.doctor_o_doctora(sexo)
    return template(sexo)
  end

  def self.template(sexo)
    return template_method(sexo, 'Dr.', 'Dra.')
  end

  def self.inscripta_inscripto(sexo)
    template_method(sexo, 'inscripto', 'inscripta')
  end

  def self.abogada_abogado(sexo)
    template_method(sexo, 'abogado', 'abogada')
  end

  def self.la_el(sexo)
    template_method(sexo, 'el', 'la')
  end

  def self.letrada_letrado(sexo)
    template_method(sexo, 'letrado', 'letrada')
  end

  private

  def self.template_method(sexo, palabra_en_masculino, palabra_en_femenino)
    return palabra_en_masculino if el_sexo_es_masculino(sexo)
    palabra_en_femenino
  end

  def self.el_sexo_es_masculino(sexo)
    sexo == Sexo::MASCULINO
  end
end
