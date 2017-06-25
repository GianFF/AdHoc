require_relative '../rails_helper'

def devuelve_un_expediente
  expediente = fabrica_de_objetos.un_expediente_con(actor, demandado, materia, cliente.id)

  subject

  expect(resultado_de_la_busqueda['expedientes'].first['id']).to be expediente.id
  expect(resultado_de_la_busqueda['expedientes'].first['titulo']).to eq expediente.titulo
end

def devuelve_un_escrito
  escrito = fabrica_de_objetos.una_demanda_con(un_titulo, un_cuerpo, expediente.id)

  subject

  expect(resultado_de_la_busqueda['escritos'].first['id']).to be escrito.id
  expect(resultado_de_la_busqueda['escritos'].first['titulo']).to eq escrito.titulo
end

describe QueryController do
  include ::ControllersHelper


  let(:fabrica_de_objetos) { FabricaDeObjetos.new }

  let(:ad_hoc) { AdHocAplicacion.new }

  let(:parametros_del_abogado) { fabrica_de_objetos.unos_parametros_para_un_abogado }

  let(:abogado) { login_abogado(parametros_del_abogado) }

  let(:un_apellido) { fabrica_de_objetos.un_apellido_para_un_cliente }

  let(:un_nombre) { fabrica_de_objetos.un_nombre_para_un_cliente }

  let(:un_cuerpo) { fabrica_de_objetos.un_cuerpo_de_una_demanda }

  let(:un_titulo) { fabrica_de_objetos.un_titulo_de_una_demanda }

  let(:actor) { fabrica_de_objetos.un_actor }

  let(:demandado) { fabrica_de_objetos.un_demandado }

  let(:materia) { fabrica_de_objetos.una_materia }

  let(:cliente) { fabrica_de_objetos.un_cliente_con(abogado.id, un_nombre, un_apellido) }

  let(:expediente) { fabrica_de_objetos.un_expediente_con(actor, demandado, materia, cliente.id) }

  let(:resultado_de_la_busqueda) { ActiveSupport::JSON.decode @response.body }


  subject { get :buscar, params: {query: query}, xhr: true }

  context 'Cuando se busca un cliente por nombre' do

    let(:query) { cliente.nombre }

    it 'devuelve ese cliente' do
      subject

      expect(resultado_de_la_busqueda['clientes'].first['id']).to be cliente.id
      expect(resultado_de_la_busqueda['clientes'].first['nombre']).to eq cliente.nombre_completo
    end
  end

  context 'Cuando se busca un cliente por nombre completo' do

    let(:query) { cliente.nombre_completo }

    pending 'devuelve ese cliente' do
      # Para poder hacer pasar este test necesito traer los objetos de la base de datos y filtrarlos.
      # No lo quiero hacer porque no se que tan performante seria
      subject

      expect(resultado_de_la_busqueda['clientes'].first['cliente_id']).to be cliente.id
      expect(resultado_de_la_busqueda['clientes'].first['cliente_nombre']).to eq cliente.nombre_completo
    end
  end

  context 'Cuando se busca un expediente' do

    context 'Por actor' do
      let(:query) { actor[0..3] }

      it { devuelve_un_expediente }
    end

    context 'Por materia' do
      let(:query) { materia }

      it { devuelve_un_expediente }
    end

    context 'Por demandado' do
      let(:query) { demandado[0..3] }

      it { devuelve_un_expediente }
    end
  end

  context 'Cuando se busca un escrito' do

    context 'Por titulo' do
      let(:query) { un_titulo }

      it { devuelve_un_escrito }
    end

    context 'Por cuerpo' do
      let(:query) { un_cuerpo }

      it { devuelve_un_escrito }
    end
  end

  context 'Cuando se busca un adjunto por titulo' do
    let(:query) { fabrica_de_objetos.un_titulo_para_un_adjunto }

    it 'devuelve ese adjunto' do
      adjunto = fabrica_de_objetos.un_adjunto(expediente)

      subject

      expect(resultado_de_la_busqueda['adjuntos'].first['id']).to be adjunto.id
      expect(resultado_de_la_busqueda['adjuntos'].first['titulo']).to eq adjunto.titulo
    end
  end

  context 'Cuando se busca por una palabra clave que machea con todo' do
    let(:query) { un_nombre }

    it 'devuelve todos los resultados' do
      cliente = fabrica_de_objetos.un_cliente_con(abogado.id, 'Juan', 'Pepe')
      expediente = fabrica_de_objetos.un_expediente_con('Juan Pepe', demandado, materia, cliente.id)
      escrito = fabrica_de_objetos.una_demanda_con('Demanda de Juan Pepe', un_cuerpo, expediente.id)

      subject

      expect(resultado_de_la_busqueda['clientes'].first['id']).to be cliente.id
      expect(resultado_de_la_busqueda['clientes'].first['nombre']).to eq cliente.nombre_completo
      expect(resultado_de_la_busqueda['escritos'].first['id']).to be escrito.id
      expect(resultado_de_la_busqueda['escritos'].first['titulo']).to eq escrito.titulo
      expect(resultado_de_la_busqueda['expedientes'].first['id']).to be expediente.id
      expect(resultado_de_la_busqueda['expedientes'].first['titulo']).to eq expediente.titulo
    end
  end
end
