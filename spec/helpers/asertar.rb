class Asertar
  include ::RSpec::Matchers

  def initialize(fabrica_de_objetos)
    @fabrica_de_objetos = fabrica_de_objetos
  end

  def que_la_respuesta_tiene_estado(una_response, un_estado)
    expect(una_response).to have_http_status(un_estado)
  end

  def que_se_muestra_un_mensaje_de_confirmacion(un_mensaje_flash, un_mensaje)
    expect(un_mensaje_flash).to eq un_mensaje
  end

  def que_se_muestra_un_mensaje_de_error( un_mensaje_flash, un_mensaje)
    expect(un_mensaje_flash).to eq un_mensaje
  end

  def que_el_expediente_fue_correctamente_creado(un_cliente)
    un_expediente = Expediente.first

    expect(un_expediente.actor).to eq "#{un_cliente.nombre_completo}"
    expect(un_expediente.demandado).to eq 'Maria Perez'
    expect(un_expediente.materia).to eq 'Daños y Perjuicios'
  end

  def que_el_expediente_no_fue_creado
    un_expediente = Expediente.first

    expect(un_expediente).to be nil
  end

  def que_el_expediente_no_fue_numerado(un_expediente)
    expect(un_expediente.ha_sido_numerado?).to be nil
  end

  def que_el_expediente_fue_numerado(un_expediente)
    expect(un_expediente.ha_sido_numerado?).to be true
  end

  def que_un_expediente_no_pertenece_a(un_abogado, otro_abogado)
    un_expediente = Expediente.first
    expect(un_expediente.pertenece_a? un_abogado).to be true
    expect(un_expediente.pertenece_a? otro_abogado).to be false
  end

  def que_el_expediente_cambio(un_actor, un_demandado, una_materia, un_expediente)
    expect(un_expediente.actor).to eq un_actor
    expect(un_expediente.demandado).to eq un_demandado
    expect(un_expediente.materia).to eq una_materia
  end

  def que_el_expediente_no_cambio(un_actor, un_demandado, una_materia, un_expediente)
    expect(un_expediente.actor).to eq un_actor
    expect(un_expediente.demandado).to eq un_demandado
    expect(un_expediente.materia).to eq una_materia
  end

  def que_se_redirecciono_a(url)
    assert_redirected_to url
  end

  def que_se_elimino_el_expediente
    expect(Expediente.all.count).to eq 0
  end
end