class FabricaDeObjetos
  #Abogados:
  def parametros_para_un_abogado(mail, contrasenia, nombre, apellido, genero, una_matricula, un_colegio, un_cuit,
                                 un_domicilio_procesal, un_domicilio_electronico)
    {email: mail, password: contrasenia, nombre: nombre, apellido: apellido, genero: genero,
     matricula: una_matricula, nombre_del_colegio_de_abogados: un_colegio, cuit: un_cuit,
     domicilio_procesal: un_domicilio_procesal, domicilio_electronico: un_domicilio_electronico}
  end

  def crear_un_abogado(parametros_para_un_abogado)
    Abogado.create!(parametros_para_un_abogado)
  end

  def un_domicilio_electronico
    '27375970725@notificaciones.scba.gov.ar'
  end

  def otro_domicilio_electronico
    '27169652635@notificaciones.scba.gov.ar'
  end

  def un_domicilio_procesal
    'Mitre N° 262'
  end

  def otro_domicilio_procesal
    'Alvear N° 262'
  end

  def un_cuit
    '27-37597072-5'
  end

  def otro_cuit
    '27-16965263-5'
  end

  def un_colegio
    'C.A.Q'
  end

  def otro_colegio
    'C.A.A'
  end

  def una_matricula
    'T° X F° 25'
  end

  def otra_matricula
    'T° X F° 26'
  end

  def un_nombre_para_un_abogado
    'Pablo'
  end

  def un_apellido_para_un_abogado
    'Caceres'
  end

  def un_mail_para_un_abogado
    'pablo@mail.com'
  end

  def otro_nombre_para_un_abogado
    'Dulce Noelia'
  end

  def otro_apellido_para_un_abogado
    'Fioriello'
  end

  def otro_mail_para_un_abogado
    'noe@mail.com'
  end

  def una_contrasenia
    'abc123'
  end

  def una_contrasenia_incorrecta
    'password1'
  end

  #Clientes:

  def crear_cliente(abogado_id)
    Cliente.create!(nombre: un_nombre_para_un_cliente, apellido: un_apellido_para_un_cliente, abogado_id: abogado_id)
  end

  def crear_otro_cliente(abogado_id)
    Cliente.create!(nombre: otro_nombre_para_un_cliente, apellido: otro_apellido_para_un_cliente, abogado_id: abogado_id)
  end

  def un_nombre_para_un_cliente
    'Juan'
  end

  def un_apellido_para_un_cliente
    'Perez'
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
    'Juana'
  end

  def otro_apellido_para_un_cliente
    'Rosas'
  end

  def parametros_para_cliente(un_id_de_un_abogado, un_nombre, un_apellido, un_telefono=nil, un_mail=nil,
                              un_estado_civil=nil, una_empresa=nil, trabaja_en_blanco=nil)
    {
        abogado_id: un_id_de_un_abogado,
        nombre: un_nombre,
        apellido: un_apellido,
        telefono: un_telefono,
        correo_electronico: un_mail,
        estado_civil: un_estado_civil,
        empresa: una_empresa,
        trabaja_en_blanco: trabaja_en_blanco
    }
  end

  def crear_un_cliente(abogado_id, un_nombre, un_apellido)
    Cliente.create!(parametros_para_cliente(abogado_id, un_nombre, un_apellido))
  end

  #Expedientes

  def crear_expediente(cliente_id)
    Expediente.create!(actor: self.un_actor, demandado: self.un_demandado, materia: self.una_materia, cliente_id: cliente_id)
  end

  def una_caratula_numerada(expediente, numero, anio, juzgado, numero_de_juzgado, departamento, ubicacion_del_departamento)
    "#{expediente.titulo} s/ #{expediente.materia} (#{numero}/#{anio}) en tramite ante el #{juzgado} N°#{numero_de_juzgado} del #{departamento} sito en #{ubicacion_del_departamento}"
  end

  def un_actor
    'Juan Perez'
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

  #Escritos

  def crear_demanda(expediente_id)
    Demanda.create!(titulo: un_titulo_de_una_demanda, cuerpo: un_cuerpo_de_una_demanda, expediente_id: expediente_id)
  end

  def crear_contestacion_de_demanda(expediente_id)
    ContestacionDeDemanda.create!(titulo: otro_titulo_de_una_demanda, cuerpo: otro_cuerpo_de_una_demanda, expediente_id: expediente_id)
  end

  def crear_mero_tramite(expediente_id)
    MeroTramite.create!(titulo: 'Mero Tramite 01', cuerpo: otro_cuerpo_de_una_demanda, expediente_id: expediente_id)
  end

  def un_titulo_de_una_demanda
    'Demanda 01'
  end

  def un_cuerpo_de_una_demanda
    '<h1 style="text-align: center;">I.- OBJETO</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">II.- HECHOS</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">III.- DERECHO</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">IV.- PRUEBA</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">V.- PETITORIO</h1>'+
        '<p>&nbsp;</p>';
  end

  def otro_titulo_de_una_demanda
    'Contestacion de Demanda 01'
  end

  def otro_cuerpo_de_una_demanda
    '<h1 style="text-align: center;">I.- OBJETO</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">II.- HECHOS</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">III.- DERECHO</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">IV.- PRUEBA</h1>'+
        '<p>&nbsp;</p>'+
        '<h1 style="text-align: center;">V.- PETITORIO</h1>'+
        '<p>&nbsp;</p>';
  end

  #Encabezados

  def encabezado_para_demanda(abogado, expediente, cliente)
    Encabezado.new(abogado, expediente, cliente)
  end

  def encabezado_con_datos_del_expediente(abogado, expediente, cliente)
    EncabezadoConDatosDelExpediente.new(abogado, expediente, cliente)
  end

  #Adjuntos

  def un_adjunto_para(un_expediente, archivo_adjunto, un_titulo_para_un_adjunto)
    Adjunto.create!({titulo: un_titulo_para_un_adjunto, archivo_adjunto: archivo_adjunto, expediente_id: un_expediente.id})
  end

  def un_titulo_para_un_adjunto
    'Adjunto 01'
  end

  def otro_titulo_para_un_adjunto
    'otro titulo'
  end
end
