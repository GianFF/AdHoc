# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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

expediente_hombre = fabrica_de_objetos.crear_expediente(cliente_hommbre.id)
expediente_mujer = fabrica_de_objetos.crear_expediente(cliente_mujer.id)

fabrica_de_objetos.crear_demanda(expediente_hombre.id)
fabrica_de_objetos.crear_contestacion_de_demanda(expediente_hombre.id)
fabrica_de_objetos.crear_demanda(expediente_mujer.id)
fabrica_de_objetos.crear_contestacion_de_demanda(expediente_mujer.id)
