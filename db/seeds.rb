require_relative '../spec/fabrica_de_objetos'

fabrica_de_objetos = FabricaDeObjetos.new


hombre = fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.un_mail_para_un_abogado,
                                                           fabrica_de_objetos.una_contrasenia,
                                                           fabrica_de_objetos.un_nombre_para_un_abogado,
                                                           fabrica_de_objetos.un_apellido_para_un_abogado,
                                                           Sexo::MASCULINO,
                                                           fabrica_de_objetos.una_matricula,
                                                           fabrica_de_objetos.un_colegio,
                                                           fabrica_de_objetos.un_cuit,
                                                           fabrica_de_objetos.un_domicilio_procesal,
                                                           fabrica_de_objetos.un_domicilio_electronico)

mujer = fabrica_de_objetos.parametros_para_un_abogado(fabrica_de_objetos.otro_mail_para_un_abogado,
                                                           fabrica_de_objetos.una_contrasenia,
                                                           fabrica_de_objetos.otro_nombre_para_un_abogado,
                                                           fabrica_de_objetos.otro_apellido_para_un_abogado,
                                                           Sexo::FEMENINO,
                                                           fabrica_de_objetos.otra_matricula,
                                                           fabrica_de_objetos.otro_colegio,
                                                           fabrica_de_objetos.otro_cuit,
                                                           fabrica_de_objetos.otro_domicilio_procesal,
                                                           fabrica_de_objetos.otro_domicilio_electronico)


abogado_hommbre = fabrica_de_objetos.crear_un_abogado(hombre)
abogada_mujer = fabrica_de_objetos.crear_un_abogado(mujer)


cliente_hommbre = fabrica_de_objetos.crear_cliente(abogado_hommbre.id)
cliente_mujer = fabrica_de_objetos.crear_otro_cliente(abogada_mujer.id)

expediente_hombre = fabrica_de_objetos.un_expediente_para(cliente_hommbre.id)
expediente_archivado_hombre = fabrica_de_objetos.un_expediente_archivado_para(cliente_mujer.id)
expediente_mujer = fabrica_de_objetos.un_expediente_para(cliente_mujer.id)
expediente_archivado_mujer = fabrica_de_objetos.un_expediente_archivado_para(cliente_mujer.id)

fabrica_de_objetos.una_demanda_para(expediente_hombre.id)
fabrica_de_objetos.una_contestacion_de_demanda_para(expediente_hombre.id)
fabrica_de_objetos.un_mero_tramite_para(expediente_hombre.id)
fabrica_de_objetos.una_demanda_para(expediente_mujer.id)
fabrica_de_objetos.una_contestacion_de_demanda_para(expediente_mujer.id)
fabrica_de_objetos.un_mero_tramite_para(expediente_mujer.id)
