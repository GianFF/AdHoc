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
end
