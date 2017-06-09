class AdHocAplicacion

  # Abogados

  def editar_abogado!(un_abogado, parametros_abogado)
    begin
      un_abogado.update!(parametros_abogado)
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
  end

  def validar_contrasenia(contrasenia_del_abogado, abogado, &block)
    validar_que_la_contrasenia_no_sea_blanca(contrasenia_del_abogado, &block)
    validar_que_la_contrasenia_no_sea_invalida(contrasenia_del_abogado, abogado, &block)
  end

  # Clientes

  def buscar_cliente_por_nombre_o_apellido!(query, abogado_id)
    begin
      Cliente.where(['nombre like ? or apellido like ?', "%#{query}%", "%#{query}%"]).
          where('abogado_id = :abogado_id', {abogado_id: abogado_id}).
          take!
    rescue ActiveRecord::RecordNotFound
      raise AdHocUIExcepcion.new([mensaje_de_error_para_busqueda_de_cliente_fallida(query)])
    end
  end

  def buscar_cliente_por_id!(cliente_id, abogado_id)
    begin
      Cliente.find_by!({id: cliente_id, abogado_id: abogado_id})
    rescue ActiveRecord::RecordNotFound
      raise AdHocHackExcepcion.new([mensaje_de_error_para_cliente_inexistente])
    end
  end

  def crear_cliente_nuevo!(parametros_cliente, abogado_actual)
    cliente = Cliente.new(parametros_cliente)
    cliente.abogado = abogado_actual
    begin
      cliente.save!
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
    cliente
  end

  def editar_cliente!(cliente_id, parametros_cliente, abogado)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado)
    begin
      cliente.update!(parametros_cliente)
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
    cliente
  end

  def eliminar_cliente!(cliente_id, abogado_id)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado_id)
    cliente.destroy
  end

  # Expedientes:

  def buscar_expediente_por_id!(expediente_id, un_abogado)
    begin
      expediente = Expediente.find(expediente_id)
    rescue ActiveRecord::RecordNotFound
      raise AdHocUIExcepcion.new([mensaje_de_error_para_expediente_inexistente])
    end
    validar_que_el_expediente_pertenece_al_abogado(expediente, un_abogado)
    expediente
  end

  def crear_expediente_nuevo!(parametros_expediente, cliente_id, abogado)
    expediente = Expediente.new(parametros_expediente)
    expediente.cliente = buscar_cliente_por_id!(cliente_id, abogado)
    begin
      expediente.save!
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
    expediente
  end

  def editar_expediente!(expediente_id, parametros_expediente, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    begin
      expediente.validar_que_no_falte_ningun_dato_para_la_numeracion!(parametros_expediente) if expediente.ha_sido_numerado?
      expediente.update!(parametros_expediente)
    rescue ArgumentError => error # TODO: ¿ smell ?
      raise AdHocUIExcepcion.new([error.message])
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
    expediente
  end

  def eliminar_expediente!(expediente_id, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    expediente.destroy
  end

  def numerar_expediente!(datos_para_numerar_expediente, expediente_id, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    begin
      expediente.numerar!(datos_para_numerar_expediente)
    rescue Exception => error
      raise AdHocUIExcepcion.new([error.message])
    end
    expediente.update!(datos_para_numerar_expediente)
    expediente
  end

  # Escritos

  def buscar_escrito_por_id!(escrito_id, un_abogado)
    begin
      escrito = Escrito.find(escrito_id)
    rescue ActiveRecord::RecordNotFound
      raise AdHocUIExcepcion.new([mensaje_de_error_para_escrito_invalido])
    end
    validar_que_el_escrito_pertenece_al_abogado(escrito, un_abogado)
    escrito
  end

  def crear_nuevo_escrito!(un_id_de_un_expediente, un_abogado)
    escrito = yield
    escrito.expediente = buscar_expediente_por_id!(un_id_de_un_expediente, un_abogado)
    begin
      escrito.save!
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
    escrito
  end

  def crear_nueva_demanda!(parametros_de_un_escrito, un_id_de_un_expediente, un_abogado)
    crear_nuevo_escrito!(un_id_de_un_expediente, un_abogado) do
      Demanda.new(parametros_de_un_escrito)
    end
  end

  def crear_nueva_contestacion_de_demanda!(parametros_de_un_escrito, un_id_de_un_expediente, un_abogado)
    crear_nuevo_escrito!(un_id_de_un_expediente, un_abogado) do
      ContestacionDeDemanda.new(parametros_de_un_escrito)
    end
  end

  def crear_nuevo_mero_tramite!(parametros_de_un_escrito, un_id_de_un_expediente, un_abogado)
    crear_nuevo_escrito!(un_id_de_un_expediente, un_abogado) do
      MeroTramite.new(parametros_de_un_escrito)
    end
  end

  def crear_nueva_notificacion!(parametros_de_un_escrito, un_id_de_un_expediente, un_abogado)
    crear_nuevo_escrito!(un_id_de_un_expediente, un_abogado) do
      Notificacion.new(parametros_de_un_escrito)
    end
  end

  def editar_escrito!(escrito_id, parametros_escrito, un_abogado)
    escrito = self.buscar_escrito_por_id!(escrito_id, un_abogado)
    begin
      escrito.update!(parametros_escrito)
    rescue ActiveRecord::RecordInvalid => error
      raise AdHocUIExcepcion.new(error.record.errors.full_messages)
    end
    escrito
  end

  def eliminar_escrito!(escrito_id, un_abogado)
    escrito = self.buscar_escrito_por_id!(escrito_id, un_abogado)
    escrito.destroy
  end

  def validar_que_el_escrito_pertenece_al_abogado(un_escrito, un_abogado)
    raise AdHocHackExcepcion.new([mensaje_de_error_para_escrito_invalido]) unless un_escrito.pertenece_a? un_abogado
  end

  # Mensajes de error:

  def mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
    'Cliente eliminado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente
    'Cliente creado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
    'Cliente editado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_numeracion_de_un_expediente
    'Expediente numerado correctamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
    'Expediente creado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente
    'Expediente editado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente
    'Expediente eliminado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_creacion_de_un_escrito
    'Escrito creado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_edicion_de_un_escrito
    'Escrito editado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_escrito
    'Escrito eliminado satisfactoriamente'
  end


  def mensaje_de_error_para_cliente_inexistente
    'Cliente inexistente'
  end

  def mensaje_de_error_para_busqueda_de_cliente_fallida(nombre_de_cliente)
    "No se encontraron clientes con nombre: #{nombre_de_cliente}"
  end

  def mensaje_de_error_para_contrasenia_invalida
    'La contraseña es incorrecta'
  end

  def mensaje_de_error_para_contrasenia_no_proveida
    'Debes completar tu contraseña actual para poder editar tu perfil'
  end

  def mensaje_de_error_para_expediente_inexistente
    'Expediente inexistente'
  end

  def mensaje_de_error_para_escrito_invalido
    'Escrito inexistente'
  end

  def validar_que_no_haya_sido_numerado(expediente)
    begin
      expediente.validar_que_el_expediente_no_haya_sido_numerado!
    rescue StandardError => excepcion
      raise AdHocHackExcepcion.new([excepcion.message])
    end
  end

  private

  def la_contrasenia_es_valida?(contrasenia_del_abogado, abogado)
    abogado.valid_password? contrasenia_del_abogado
  end

  def la_contrasenia_es_blanca?(contrasenia_del_abogado)
    contrasenia_del_abogado.blank?
  end

  def validar_que_la_contrasenia_no_sea_invalida(contrasenia_del_abogado, abogado, &block)
    unless la_contrasenia_es_valida?(contrasenia_del_abogado, abogado)
      block.call(mensaje_de_error_para_contrasenia_invalida)
    end
  end

  def validar_que_la_contrasenia_no_sea_blanca(contrasenia_del_abogado, &block)
    if la_contrasenia_es_blanca?(contrasenia_del_abogado)
      block.call(mensaje_de_error_para_contrasenia_no_proveida)
    end
  end

  def validar_que_el_expediente_pertenece_al_abogado(expediente, un_abogado)
    raise AdHocHackExcepcion.new([mensaje_de_error_para_expediente_inexistente]) unless expediente.pertenece_a? un_abogado
  end
end
