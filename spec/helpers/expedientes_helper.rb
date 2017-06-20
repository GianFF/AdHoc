module ExpedientesHelper
  include ::RSpec::Matchers

  def asertar_que_el_expediente_fue_correctamente_creado
    un_expediente = Expediente.first

    expect(un_expediente.actor).to eq "#{cliente.nombre_completo}"
    expect(un_expediente.demandado).to eq fabrica_de_objetos.un_demandado
    expect(un_expediente.materia).to eq fabrica_de_objetos.una_materia
  end

  def asertar_que_el_expediente_no_fue_creado
    un_expediente = Expediente.first

    expect(un_expediente).to be nil
  end

  def asertar_que_el_expediente_no_fue_numerado
    expect(expediente.ha_sido_numerado?).to be false
  end

  def asertar_que_el_expediente_fue_numerado
    expect(expediente.ha_sido_numerado?).to be true
  end

  def asertar_que_un_expediente_no_pertenece_a(otro_abogado)
    un_expediente = Expediente.first
    expect(un_expediente.pertenece_a? abogado).to be true
    expect(un_expediente.pertenece_a? otro_abogado).to be false
  end

  def asertar_que_el_expediente_cambio(un_actor, un_demandado, una_materia)
    expect(expediente.actor).to eq un_actor
    expect(expediente.demandado).to eq un_demandado
    expect(expediente.materia).to eq una_materia
  end

  def asertar_que_el_expediente_no_cambio(un_actor, un_demandado, una_materia)
    expect(expediente.actor).to eq un_actor
    expect(expediente.demandado).to eq un_demandado
    expect(expediente.materia).to eq una_materia
  end

  def asertar_que_el_escrito_no_cambio(un_escrito, un_titulo, un_cuerpo)
    expect(un_escrito.titulo).to eq un_titulo
    expect(un_escrito.cuerpo).to eq un_cuerpo
  end

  def asertar_que_se_elimino_el_expediente
    expect(Expediente.all.count).to eq 0
  end

  def numerar_expediente
    post :realizar_numeraracion,
         params: {
             id: expediente.id,
             cliente_id: cliente.id,
             expediente: {
                 actor: "#{cliente.nombre_completo}",
                 demandado: fabrica_de_objetos.un_demandado,
                 materia: fabrica_de_objetos.una_materia,
                 numero: fabrica_de_objetos.un_numero_de_expediente,
                 juzgado: fabrica_de_objetos.un_juzgado,
                 numero_de_juzgado: fabrica_de_objetos.un_numero_de_juzgado,
                 departamento: fabrica_de_objetos.un_departamento,
                 ubicacion_del_departamento: fabrica_de_objetos.una_ubicacion_de_un_departamento
             }
         }
  end
end