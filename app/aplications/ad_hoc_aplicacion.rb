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

  def crear_cliente_nuevo!(parametros_cliente, abogado_actual)
    cliente = Cliente.new(parametros_cliente)
    cliente.abogado = abogado_actual
    cliente.save!
    cliente
  end

  def editar_cliente!(cliente_id, parametros_cliente, abogado)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado)
    cliente.update!(parametros_cliente)
    cliente
  end

  def eliminar_cliente!(cliente_id, abogado_id)
    cliente = self.buscar_cliente_por_id!(cliente_id, abogado_id)
    cliente.destroy
  end

  # Expedientes:

  def crear_expediente_nuevo!(parametros_expediente, cliente_id, abogado)
    expediente = Expediente.new(parametros_expediente)
    expediente.cliente = buscar_cliente_por_id!(cliente_id, abogado)
    expediente.save!
    expediente
  end

  def buscar_expediente_por_id!(expediente_id, un_abogado)
    expediente = Expediente.find(expediente_id)
    # TODO: que pasa si el expediente no pertenece al cliente?
    raise ActiveRecord::RecordNotFound unless expediente.pertenece_a? un_abogado
    expediente
  end

  def editar_expediente!(expediente_id, parametros_expediente, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    expediente.update!(parametros_expediente)
    expediente
  end

  def eliminar_expediente!(expediente_id, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    expediente.destroy
  end

  def numerar_expediente!(datos_para_numerar_expediente, expediente_id, abogado)
    expediente = self.buscar_expediente_por_id!(expediente_id, abogado)
    expediente.numerar!(datos_para_numerar_expediente)
    expediente.update!(datos_para_numerar_expediente)
    expediente
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

  def mensaje_de_error_para_expediente_invalido
    'El Actor, Demandado, y Materia no pueden ser vacios'
  end

  def mensaje_de_error_para_expediente_inexistente
    'Expediente inexistente'
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
