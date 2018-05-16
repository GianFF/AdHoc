class AdHocAplicacion

  # Escritos

  def buscar_escrito_por_id!(escrito_id, un_abogado)
    begin
      escrito = Escrito.find(escrito_id) #TODO: deberia recibir el expediente_id tambien y buscar por los dos campos.
    rescue ActiveRecord::RecordNotFound
      raise Errores::AdHocDomainError.new([mensaje_de_error_para_escrito_invalido])
    end
    validar_que_pertenece_al_abogado(escrito, un_abogado, mensaje_de_error_para_escrito_invalido)
    escrito
  end

  def crear_nuevo_escrito!(un_id_de_un_expediente, un_abogado)
    escrito = yield
    escrito.expediente = buscar_expediente_por_id!(un_id_de_un_expediente, un_abogado)
    begin
      escrito.save!
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
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
      escrito.validar_que_no_haya_sido_presentado
      escrito.update!(parametros_escrito)
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
    escrito
  end

  def eliminar_escrito!(escrito_id, un_abogado)
    escrito = self.buscar_escrito_por_id!(escrito_id, un_abogado)
    escrito.destroy
  end

  def presentar_escrito!(un_escrito_id, un_abogado)
    escrito = self.buscar_escrito_por_id!(un_escrito_id, un_abogado)
    escrito.marcar_como_presentado!
    escrito.save!
    escrito
  end

  # Adjuntos

  def buscar_adjunto_por_id!(adjunto_id, expediente_id, un_abogado)
    begin
      adjunto = Adjunto.find_by!({id: adjunto_id, expediente_id: expediente_id})
    rescue ActiveRecord::RecordNotFound
      raise Errores::AdHocDomainError.new([mensaje_de_error_para_adjunto_invalido])
    end
    validar_que_pertenece_al_abogado(adjunto, un_abogado, mensaje_de_error_para_adjunto_invalido)
    adjunto
  end

  def crear_nuevo_adjunto!(parametros_adjunto, expediente_id, abogado_actual)
    adjunto = Adjunto.new(parametros_adjunto)
    adjunto.expediente = buscar_expediente_por_id!(expediente_id, abogado_actual)
    begin
      adjunto.save!
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
    adjunto
  end

  def editar_adjunto!(adjunto_id, expediente_id, un_abogado, parametros_adjunto)
    adjunto = buscar_adjunto_por_id!(adjunto_id, expediente_id, un_abogado)
    begin
      adjunto.update!(parametros_adjunto)
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
    adjunto
  end

  # Mensajes de error:

  def mensaje_de_confirmacion_para_la_correcta_creacion_de_un_escrito
    'Escrito creado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_edicion_de_un_escrito
    'Escrito editado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_escrito
    'Escrito eliminado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_presentacion_de_un_escrito
    'Escrito marcado como presentado correctamente'
  end


  def mensaje_de_error_para_busqueda_de_cliente_fallida(nombre_de_cliente)
    "No se encontraron clientes con nombre: #{nombre_de_cliente}"
  end

  def mensaje_de_error_para_contrasenia_no_proveida
    'Debes completar tu contraseña actual para poder editar tu perfil'
  end

  def mensaje_de_error_para_cliente_inexistente
    'Cliente inexistente'
  end

  def mensaje_de_error_para_escrito_invalido
    'Escrito inexistente'
  end

  def mensaje_de_error_para_adjunto_invalido
    'Adjunto inexsitente'
  end

  # Validaciones

  def validar_que_pertenece_al_abogado(una_cosa, un_abogado, un_mensaje_de_error)
    raise Errores::AdHocHackExcepcion.new([un_mensaje_de_error]) unless una_cosa.pertenece_a? un_abogado
  end
end
