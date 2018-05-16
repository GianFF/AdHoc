class AdHocExpedientes

  def buscar_expediente_por_id!(expediente_id, un_abogado)
    expediente = buscar_expediente!(expediente_id)
    validar_que_pertenece_al_abogado(expediente, un_abogado, mensaje_de_error_para_expediente_inexistente)
    expediente
  end

  def crear_expediente_nuevo!(parametros_expediente, cliente_id, abogado)
    expediente = Expediente.new(parametros_expediente)
    expediente.cliente = AdHocClientes.new.buscar_cliente_por_id!(cliente_id, abogado)
    guardar_expediente!(expediente)
    expediente
  end

  def editar_expediente!(expediente_id, parametros_expediente, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    begin
      expediente.validar_datos_para_numerar(parametros_expediente) if expediente.ha_sido_numerado?
      expediente.update!(parametros_expediente)
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
    expediente
  end

  def eliminar_expediente!(expediente_id, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    expediente.destroy
  end

  def numerar_expediente!(datos_para_numerar_expediente, expediente_id, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    expediente.numerar(datos_para_numerar_expediente)
    expediente.update!(datos_para_numerar_expediente)
    expediente
  end


  def mensaje_de_error_para_expediente_inexistente
    'Expediente inexistente'
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


  def validar_que_no_haya_sido_numerado(expediente)
    begin
      expediente.validar_que_se_puede_numerar
    rescue StandardError => excepcion
      raise Errores::AdHocHackExcepcion.new([excepcion.message])
    end
  end

  def validar_que_pertenece_al_abogado(una_cosa, un_abogado, un_mensaje_de_error)
    raise Errores::AdHocHackExcepcion.new([un_mensaje_de_error]) unless una_cosa.pertenece_a? un_abogado
  end

  #TODO: lógica encapsulable en ExpedientesResource

  def buscar_expediente!(expediente_id)
    begin
      return Expediente.find(expediente_id)
    rescue ActiveRecord::RecordNotFound
      raise Errores::AdHocDomainError.new([mensaje_de_error_para_expediente_inexistente])
    end
  end

  def guardar_expediente!(expediente)
    begin
      expediente.save!
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
  end
end
