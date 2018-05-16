require 'rails_helper'

describe AdHocExpedientes do
  include FactoryBot::Syntax::Methods

  let(:abogado){ create(:abogado) }
  let(:cliente){ create(:cliente, abogado: abogado) }
  let(:expediente){ create(:expediente, cliente: cliente) }
  let(:otro_expediente){ create(:expediente_de_clienta) }
  let(:ad_hoc){ AdHocExpedientes.new }

  describe '#crear_expediente_nuevo!' do
    subject { ad_hoc.crear_expediente_nuevo!(parametros, cliente.id, abogado) }

    context 'en la correcta creacion de un expediente' do
      let(:parametros){attributes_for(:expediente)}

      it 'un abogado no puede ver los expedientes de otro abogado' do
        subject

        abogada = create(:abogada)
        un_expediente = Expediente.first

        expect(un_expediente.pertenece_a? abogado).to be true
        expect(un_expediente.pertenece_a? abogada).to be false
      end
    end

    context 'en la incorrecta creacion de un cliente' do

      context 'sin materia no puede ser creado' do
        let(:parametros){attributes_for(:expediente, materia: '')}

        it {expect{subject}.to raise_error Errores::AdHocDomainError}
      end

      context 'sin actor no puede ser creado' do
        let(:parametros){attributes_for(:expediente, actor: '')}

        it {expect{subject}.to raise_error Errores::AdHocDomainError}
      end

      context 'sin demandado no puede ser creado' do
        let(:parametros){attributes_for(:expediente, demandado: '')}

        it {expect{subject}.to raise_error Errores::AdHocDomainError}
      end
    end
  end

  describe '#buscar_expediente_por_id!' do

    subject { ad_hoc.buscar_expediente_por_id!(expediente_id, abogado) }

    let(:expediente_id){ expediente.id }

    it 'cuando el expediente buscado existe lo encuentra' do
      expect(subject).to eq expediente
    end

    context 'no lo encuentra' do

      context 'cuando no es propio' do
        let(:expediente_id){ otro_expediente.id }

        it{expect{subject}.to raise_error Errores::AdHocHackExcepcion}
      end

      context 'cuando no existe' do
        let(:expediente_id){ 1 }

        it {expect{subject}.to raise_error(Errores::AdHocDomainError)}
      end
    end
  end

  describe '#editar_expediente!' do
    subject { ad_hoc.editar_expediente!(expediente.id, attributes_for(:expediente, actor: ''), abogado) }

    it 'ninguno de los campos obligatorios pueden ser vacíos' do
      expect{subject}.to raise_error Errores::AdHocDomainError
      expect(expediente.actor).to eq 'Juan Pepe'
      expect(expediente.demandado).to eq 'Maria Perez'
      expect(expediente.materia).to eq 'Daños y Perjuicios'
    end

    it 'un abogado no puede editar un expediente que no le corresponde' do
      otro_expediente = create(:expediente_de_clienta)

      expect{ad_hoc.editar_expediente!(otro_expediente.id, attributes_for(:expediente), abogado)}.to raise_error Errores::AdHocHackExcepcion
    end
  end

  describe '#eliminar_expediente!' do
    subject { ad_hoc.eliminar_expediente!(expediente_id, abogado)}

    context 'se puede eliminar un expediente' do
      let(:expediente_id){ expediente.id }

      it 'cuando es propio' do
        subject

        expect(Expediente.all.count).to eq 0
      end
    end

    context 'no se puede eliminar un expediente' do
      let(:expediente_id){ otro_expediente.id }

      it 'cuando no es propio' do
        otro_expediente = create(:expediente_de_clienta)

        expect{ad_hoc.eliminar_expediente!(otro_expediente.id, abogado)}.to raise_error Errores::AdHocHackExcepcion
        expect(Expediente.all.count).to eq 1
      end
    end
  end

  describe '#numerar_expediente!' do
    subject { ad_hoc.numerar_expediente!(datos_para_numerar_expediente, expediente_id, abogado) }

    let(:datos_para_numerar_expediente){ attributes_for(:expediente_numerado) }
    let(:expediente_id){ expediente.id }

    context 'se puede numerar un expediente' do
      it 'cuando le pertenece' do
        subject

        expediente.reload

        expect(expediente.ha_sido_numerado?).to be true
      end
    end

    context 'no se puede numerar un expediente' do

      context 'cuando no le pertenece' do
        let(:expediente_id){ otro_expediente.id }

        it{ expect{subject}.to raise_error(Errores::AdHocHackExcepcion) }
      end

      context 'cuando ya fue numerado' do
        before { ad_hoc.numerar_expediente!(datos_para_numerar_expediente, expediente_id, abogado) }

        it{ expect{subject}.to raise_error(Errores::AdHocDomainError) }
      end

      context 'cuando los datos estan incompletos' do
        let(:datos_para_numerar_expediente){ attributes_for(:expediente_numerado, actor: '') }

        it{ expect{subject}.to raise_error(Errores::AdHocDomainError) }
      end
    end
  end
end
