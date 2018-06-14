require 'rails_helper'

describe AdHocEscritos do
  include FactoryBot::Syntax::Methods

  let(:abogado){ create(:abogado) }
  let(:abogada){ create(:abogada) }

  let(:cliente){ create(:cliente, abogado: abogado) }
  let(:escrito){ create(:demanda, expediente: expediente) }
  let(:escrito_id){ escrito.id }
  let(:expediente){ create(:expediente, cliente: cliente) }

  let(:otro_cliente){ create(:cliente, abogado: abogada) }
  let(:otro_expediente){ create(:expediente, cliente: otro_cliente) }
  let(:otro_escrito){ create(:demanda, expediente: otro_expediente) }
  let(:otro_escrito_id){ otro_escrito.id }

  let(:parametros_escrito){{cuerpo: 'un cuerpo', titulo: 'un titulo'}}

  let(:ad_hoc){ AdHocEscritos.new }

  describe '#crear_escrito' do
    let(:tipo_de_escrito){Escritos::Demanda}
    subject { ad_hoc.crear_escrito(expediente.id, abogado, tipo_de_escrito, parametros_escrito) }

    context 'en la correcta creacion de un escrito' do

      it 'un abogado no puede ver los escritos de otro abogado' do
        subject

        abogada = create(:abogada)
        expect(Escritos::Escrito.count).to eq 1
        un_escrito = Escritos::Escrito.first

        expect(un_escrito.pertenece_a? abogado).to be true
        expect(un_escrito.pertenece_a? abogada).to be false
      end

      context 'una demanda puede tener cuerpo vacio' do
        let(:parametros_escrito){{cuerpo: '', titulo: 'un titulo'}}

        it {expect(subject.cuerpo).to eq ''}
        it {expect(subject.titulo).to eq 'un titulo'}
      end

      context 'un mero_tramite puede tener cuerpo vacio' do
        let(:parametros_escrito){{cuerpo: '', titulo: 'un titulo'}}
        let(:tipo_de_escrito){Escritos::MeroTramite}

        it {expect(subject.cuerpo).to eq ''}
        it {expect(subject.titulo).to eq 'un titulo'}
      end

      context 'una contestacion de demanda puede tener cuerpo vacio' do
        let(:parametros_escrito){{cuerpo: '', titulo: 'un titulo'}}
        let(:tipo_de_escrito){Escritos::ContestacionDeDemanda}

        it {expect(subject.cuerpo).to eq ''}
        it {expect(subject.titulo).to eq 'un titulo'}
      end
    end

    context 'en la incorrecta creacion de un escrito' do

      context 'con titulo vacío lanza error de dominio' do
        let(:parametros_escrito){{cuerpo: '', titulo: ''}}

        it {expect{subject}.to raise_error Errores::AdHocDomainError}
      end

      context 'sin titulo lanza error de dominio' do
        let(:parametros_escrito){{cuerpo: '', titulo: nil}}

        it {expect{subject}.to raise_error Errores::AdHocDomainError}
      end
    end
  end

  describe '#buscar_escrito_por_id' do
    subject { ad_hoc.buscar_escrito_por_id(escrito_id, abogado) }

    it 'cuando el escrito buscado existe lo encuentra' do
      expect(subject).to eq escrito
    end

    context 'no lo encuentra' do

      context 'cuando no es propio' do
        let(:escrito_id){ otro_escrito_id }

        it{expect{subject}.to raise_error Errores::AdHocHackExcepcion}
      end

      context 'cuando no existe' do
        let(:escrito_id){ 1 }

        it {expect{subject}.to raise_error(Errores::AdHocDomainError)}
      end
    end
  end

  describe '#editar_escrito' do

    subject { ad_hoc.editar_escrito(escrito_id, parametros_escrito, abogado) }

    context 'en la correcta edicion de un escrito' do
      let(:parametros_escrito){{cuerpo: 'otro cuerpo', titulo: 'otro titulo'}}

      it 'el abogado puede editar el escrito' do
        escrito = subject
        escrito.reload

        expect(escrito.titulo).to eq 'otro titulo'
        expect(escrito.cuerpo).to eq 'otro cuerpo'
      end
    end

    context 'en la incorrecta edicion de un escrito' do

      context 'cuando el escrito no le pertenece al abogado' do
        subject { ad_hoc.editar_escrito(otro_escrito_id, parametros_escrito, abogado) }

        it ' lanza un error' do
          expect{subject}.to raise_error(Errores::AdHocHackExcepcion)
          expect(escrito.titulo).to eq 'un titulo'
          expect(escrito.cuerpo).to eq 'un cuerpo'
        end
      end

      #TODO: no estoy seguro si tiene sentido que un escrito tenga un titulo, quizás un cuerpo bastaría
      # (y quizás este módulo deberia extraerse a algún otro microservicio en otro lenguaje)
      context 'cuando elimina el titulo' do
        let(:parametros_escrito){{cuerpo: 'un cuerpo', titulo: ''}}

        it ' lanza un error de dominio' do
          expect{subject}.to raise_error(Errores::AdHocDomainError)
          expect(escrito.titulo).to eq 'un titulo'
          expect(escrito.cuerpo).to eq 'un cuerpo'
        end
      end
    end
  end

  describe '#eliminar_escrito' do
    subject { ad_hoc.eliminar_escrito(escrito_id, abogado)}

    context 'en la correcta eliminacion de un escrito' do

      it 'el abogado puede elimninar un escrito y éste ya no existe' do
        escrito #fuerzo la creación de un escrito
        expect(Escritos::Escrito.count).to eq 1

        subject

        expect(Escritos::Escrito.count).to eq 0
      end
    end

    context 'en la incorrecta eliminaciónde un escrito' do

      context 'cuando el escrito no le pertenece' do
        let(:escrito_id){otro_escrito_id}
        it 'lanza un error' do
          expect{subject}.to raise_error Errores::AdHocHackExcepcion
          expect(Escritos::Escrito.count).to eq 1
        end
      end

      context 'cuando el escrito no existe' do
        let(:escrito_id){0}
        it 'lanza un error de dominio' do
          escrito #fuerzo la creación de un escrito

          expect{subject}.to raise_error Errores::AdHocDomainError
          expect(Escritos::Escrito.count).to eq 1
        end
      end
    end
  end

  describe '#presentar_escrito' do
    subject{ad_hoc.presentar_escrito(escrito_id, abogado)}

    context 'en la correcta presentación de un escrito' do

      it 'un escrito que ha sido presentado sabe que lo fue' do
        escrito = subject

        expect(escrito.presentado).to be true
      end

      it 'un escrito puede presentarse una sóla vez' do
        escrito = subject

        expect{escrito.marcar_como_presentado!}.to raise_error Errores::AdHocDomainError
      end
    end

    context 'en la incorrecta presentación de un escrito' do

      context 'presentar un escrito que no le pertenece a un abogado' do
        let(:escrito_id){otro_escrito_id}

        it 'lanza un error' do
          expect{subject}.to raise_error Errores::AdHocHackExcepcion
          expect(otro_escrito.presentado).to be false
        end
      end

      context 'presentar un escrito que no existe' do
        let(:escrito_id){0}

        it 'lanza un error de dominio' do
          expect{subject}.to raise_error Errores::AdHocDomainError
        end
      end
    end
  end
end
