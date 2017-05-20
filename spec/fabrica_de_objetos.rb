class FrabricaDeObjetos
  # Abogados:
  def un_abogado(mail, contrasenia, nombre, apellido, sexo)
    Abogado.create!(email: mail, password: contrasenia, nombre: nombre, apellido: apellido, sexo: sexo)
  end

  def un_nombre_para_un_abogado
    'Foo'
  end

  def un_apellido_para_un_abogado
    'Bar'
  end

  def un_mail_para_un_abogado
    'ejemplo@mail.com'
  end

  def otro_nombre_para_un_abogado
    'Bar'
  end

  def otro_apellido_para_un_abogado
    'Zaz'
  end

  def otro_mail_para_un_abogado
    'otro_ejemplo@mail.com'
  end

  def una_contrasenia
    'password'
  end

  def una_contrasenia_incorrecta
    'password1'
  end

  def un_demandado
    'Maria Perez'
  end

  def una_materia
    'Daños y Perjuicios'
  end

  # Clientes:

  def crear_cliente(abogado_id)
    Cliente.create!(nombre: 'Foo', apellido: 'Bar', abogado_id: abogado_id)
  end

  def un_nombre_para_un_cliente
    'Foo'
  end

  def un_apellido_para_un_cliente
    'Bar'
  end

  # Expedientes

  def una_caratula_numerada(expediente, numero, anio, juzgado, numero_de_juzgado, departamento, ubicacion_del_departamento)
    "#{expediente.titulo} s/ #{expediente.materia} (#{numero}/#{anio}) en tramite ante el #{juzgado} N°#{numero_de_juzgado} del #{departamento} sito en #{ubicacion_del_departamento}"
  end

  def una_ubicacion_de_un_departamento
    'Alvear 465 piso N°1 de Quilmes'
  end

  def un_departamento
    'Departamento Judicial de Quilmes'
  end

  def un_numero_de_juzgado
    7
  end

  def un_juzgado
    'Juzgado Civil y Comercial'
  end

  def un_anio
    DateTime.now.year % 100
  end

  def un_numero_de_expediente
    123
  end
end
