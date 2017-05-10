class AdHocAplicacion

  # Abogados

  def validar_contrasenia(contrasenia_del_abogado, abogado, &block)
    validar_que_la_contrasenia_no_sea_blanca(contrasenia_del_abogado, &block)
    validar_que_la_contrasenia_no_sea_invalida(contrasenia_del_abogado, abogado, &block)
  end

  # Clientes

  def buscar_cliente_por_nombre_o_apellido!(query, abogado_id)
    Cliente.where(['nombre like ? or apellido like ?', "%#{query}%", "%#{query}%"]).
        where('abogado_id = :abogado_id', {abogado_id: abogado_id}).
        take!
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

  # Expedientes:

  def crear_expediente_nuevo!(parametros_expediente, cliente_id)
    expediente = Expediente.new(parametros_expediente)
    expediente.cliente = buscar_cliente_por_id(cliente_id)
    expediente.save!
    expediente
  end

  def buscar_expediente_por_id!(expediente_id)
    Expediente.find(expediente_id)
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

  def mensaje_de_error_para_cliente_inexistente
    'Cliente inexistente'
  end

  def mensaje_de_error_para_busqueda_de_cliente_fallida(nombre_de_cliente)
    "No se encontraron clientes con nombre: #{nombre_de_cliente}"
  end

  def mensaje_de_error_para_nombre_y_apellido_vacios
    'El nombre y el apellido no pueden ser vacios'
  end

  def mensaje_de_error_para_contrasenia_invalida
    'La contraseña es incorrecta'
  end

  def mensaje_de_error_para_contrasenia_no_proveida
    'Debes completar tu contraseña actual para poder editar tu perfil'
  end

  def mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
    'Expediente creado satisfactoriamente'
  end

  def mensaje_de_error_para_expediente_invalido
    'El Actor, Demandado, y Materia no pueden ser vacios'
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
end
