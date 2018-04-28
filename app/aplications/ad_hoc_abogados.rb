class AdHocAbogados

  def editar_abogado!(un_abogado, parametros_abogado)
    validar_password(un_abogado.id, parametros_abogado[:encrypted_password])

    begin
      un_abogado.update!(parametros_abogado)
    rescue ActiveRecord::RecordInvalid => error
      raise Errores::AdHocDomainError.new(error.record.errors.full_messages)
    end
  end

  def validar_password(abogado_id, password)
    abogado =  Abogado.find_by_id(abogado_id)

    unless abogado.valid_password?(password)
      raise Errores::AdHocDomainError.new(mensaje_de_error_para_contrasenia_incorrecta)
    end
  end

  def mensaje_de_error_para_contrasenia_incorrecta
    'La contraseña es incorrecta'
  end
end
