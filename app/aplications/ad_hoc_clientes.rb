class AdHocClientes

  def crear_cliente_nuevo!(parametros_cliente, abogado_actual)
    cliente = Cliente.new(parametros_cliente)
    cliente.abogado = abogado_actual
    begin
      cliente.save!
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
    cliente
  end

  def editar_cliente!(cliente_id, parametros_cliente, abogado)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado)
    begin
      cliente.update!(parametros_cliente)
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
    cliente
  end

  def eliminar_cliente!(cliente_id, abogado_id)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado_id)
    cliente.destroy
  end

  def buscar_cliente_por_nombre_o_apellido!(query, abogado_id)
    begin
      Cliente.where(['nombre like ? or apellido like ?', "%#{query}%", "%#{query}%"]).
          where('abogado_id = :abogado_id', {abogado_id: abogado_id}).
          take!
    rescue ActiveRecord::RecordNotFound
      raise Errores::AdHocDomainError.new([mensaje_de_error_para_busqueda_de_cliente_fallida(query)])
    end
  end

  def buscar_cliente_por_id!(cliente_id, abogado_id)
    begin
      Cliente.find_by!({id: cliente_id, abogado_id: abogado_id})
    rescue ActiveRecord::RecordNotFound
      raise Errores::AdHocHackExcepcion.new([mensaje_de_error_para_cliente_inexistente])
    end
  end


  def mensaje_de_error_para_busqueda_de_cliente_fallida(nombre_de_cliente)
    "No se encontraron clientes con nombre: #{nombre_de_cliente}"
  end

  def mensaje_de_error_para_cliente_inexistente
    'Cliente inexistente'
  end

  def mensaje_cliente_creado_correctamente
    'Cliente creado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
    'Cliente eliminado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
    'Cliente editado satisfactoriamente'
  end
end
