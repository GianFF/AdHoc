class FabricaDeObjetos
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

  def un_telefono_para_un_cliente
    42545254
  end

  def un_mail_para_un_cliente
    'foo@bar.com'
  end

  def una_empresa_para_un_cliente
    'Edymberg'
  end

  def otro_nombre_para_un_cliente
    'Zaz'
  end

  def otro_apellido_para_un_cliente
    'Foo'
  end

  def parametros_para_cliente(un_id_de_un_abogado, un_nombre, un_apellido, un_telefono=nil, un_mail=nil, un_estado_civil=nil, una_empresa=nil, trabaja_en_blanco=nil)
    {
        abogado_id: un_id_de_un_abogado,
        nombre: un_nombre,
        apellido: un_apellido,
        telefono: un_telefono,
        correo_electronico: un_mail,
        estado_civil: un_estado_civil,
        empresa: una_empresa,
        esta_en_blanco: trabaja_en_blanco
    }
  end

  def crear_un_cliente(abogado_id, un_nombre, un_apellido)
    Cliente.create!(parametros_para_cliente(abogado_id, un_nombre, un_apellido))
  end

  # Expedientes

  def una_caratula_numerada(expediente, numero, anio, juzgado, numero_de_juzgado, departamento, ubicacion_del_departamento)
    "#{expediente.titulo} s/ #{expediente.materia} (#{numero}/#{anio}) en tramite ante el #{juzgado} N°#{numero_de_juzgado} del #{departamento} sito en #{ubicacion_del_departamento}"
  end

  def un_demandado
    'Maria Perez'
  end

  def una_materia
    'Daños y Perjuicios'
  end

  def otro_actor
    'Otro Actor'
  end

  def otro_demandado
    'Otro Demandado'
  end

  def otra_materia
    'Otra Materia'
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
