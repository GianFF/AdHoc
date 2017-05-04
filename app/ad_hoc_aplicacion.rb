class AdHocAplicacion

  def buscar_cliente_por_nombre_o_apellido!(query, abogado_id)
    #TODO: la query se forma mal. Al parecer la precedencia del and y el or no esta bien, ver de separar el abogado_id del resto de la query.
    Cliente.where(
        ['nombre like ? or apellido like ? and abogado_id = ?', "%#{query}%", "%#{query}%", abogado_id]
    ).take!
  end

  def buscar_cliente_por_id!(cliente_id, abogado_id)
    Cliente.where(["id = ? and abogado_id = ?", cliente_id, abogado_id]).take!
  end

  def buscar_cliente_por_id(cliente_id)
    Cliente.find(cliente_id)
  end

  def crear_cliente_nuevo!(parametros_cliente, abogado_actual)
    cliente = Cliente.new(parametros_cliente)
    cliente.abogado = abogado_actual
    cliente.save!
    cliente
  end

  def editar_cliente!(cliente, parametros_cliente)
    cliente.update!(parametros_cliente)
  end


  def eliminar_cliente!(cliente_id, abogado_id)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado_id)
    cliente.destroy
  end

  def mensaje_de_confirmacion_para_correcta_eliminacion_de_un_cliente
    'Cliente eliminado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_creacion_de_un_cliente
    'Cliente creado satisfactoriamente'
  end

  def mensaje_de_confirmacion_para_la_correcta_edicion_de_un_cliente
    'Cliente editado satisfactoriamente'
  end

  def mensaje_de_error_para_cliente_inexistente
    'Cliente inexistente'
  end

  def mensaje_de_error_para_busqueda_de_cliente_fallida(nombre_de_cliente)
    "No se encontraron clientes con nombre: #{nombre_de_cliente}"
  end

  def mensaje_de_error_para_nombre_y_apellido_vacios
    'El nombre y el apellido no pueden ser vacios'
  end
end
