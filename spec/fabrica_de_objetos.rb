class FrabricaDeObjetos
  def un_abogado
    Abogado.create!(email: 'ejemplo@mail.com', password: 'password', nombre: 'Foo', apellido: 'Bar', sexo: 'Masculino')
  end
  
  def un_nombre_para_un_abogado
    'Bar'
  end

  def un_apellido_para_un_abogado
    'Zaz'
  end

  def una_contrasenia_para_un_abogado
    'password'
  end
end
