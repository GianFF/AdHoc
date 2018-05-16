require 'rails_helper'

describe ExpedientesController do
  include FactoryBot::Syntax::Methods
  include ::ControllersHelper
  include ::ExpedientesHelper

  let(:abogado){ abogado_logeado }
  let(:cliente){ create(:cliente, abogado: abogado) }
  let(:expediente){ create(:expediente, cliente: cliente) }
  let(:ad_hoc){ AdHocExpedientes.new }

  describe '#create' do
    subject { post :create, params: parametros }

    let(:parametros) do
      {
          expediente: attributes_for(:expediente, actor: cliente.nombre_completo),
          cliente_id: cliente.id
      }
    end

    context 'cuando todo sale bien' do

      it 'te redirije a la vista del expediente con un mensaje de confirmacion' do
        subject

        expect(response).to have_http_status :ok
        assert_template :show
        expect(flash[:success]).to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
      end
    end

    context 'cuando falta algún parametro' do

      context 'sin actor' do

        let(:parametros) do
          {
              expediente: attributes_for(:expediente, actor: nil),
              cliente_id: cliente.id
          }
        end

        it 'devuelve un mensaje de error y bad_request' do
          subject

          expect(response).to have_http_status(:bad_request)
          assert_template :new
          expect(flash[:error]).to include "Actor #{Expediente.mensaje_de_error_para_campo_vacio}"
          expect(Expediente.count).to be 0
        end
      end

      context 'sin demandado' do

        let(:parametros) do
          {
              expediente: attributes_for(:expediente, demandado: nil),
              cliente_id: cliente.id
          }
        end

        it 'devuelve un mensaje de error y bad_request' do
          subject

          expect(response).to have_http_status(:bad_request)
          assert_template :new
          expect(flash[:error]).to include "Demandado #{Expediente.mensaje_de_error_para_campo_vacio}"
          expect(Expediente.count).to be 0
        end
      end

      context 'sin materia' do

        let(:parametros) do
          {
              expediente: attributes_for(:expediente, materia: nil),
              cliente_id: cliente.id
          }
        end

        it 'devuelve un mensaje de error y bad_request' do
          subject

          expect(response).to have_http_status(:bad_request)
          assert_template :new
          expect(flash[:error]).to include "Materia #{Expediente.mensaje_de_error_para_campo_vacio}"
          expect(Expediente.count).to be 0
        end
      end
    end
  end

  describe '#update' do
    subject do
      put :update, params: parametros
    end

    context 'en la correcta edicion de un Expediente' do
      let(:parametros) do
        {
            id: expediente.id,
            expediente: attributes_for(:expediente),
            cliente_id: cliente.id,
        }
      end

      it 'devuelve un mensaje de confirmación y estado ok' do
        subject

        expect(response).to have_http_status(:ok)
        expect(flash[:success]).to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente
      end
    end

    context 'en la incorrecta edicion de un Expediente' do

      context 'sin actor' do
        let(:parametros) do
          {
              id: expediente.id,
              expediente: attributes_for(:expediente, actor: ''),
              cliente_id: cliente.id,
          }
        end

        it 'devuelve un mensaje de error y bad_request' do
          subject

          expect(response).to have_http_status(:bad_request)
          expect(flash[:error]).to include "Actor #{Expediente.mensaje_de_error_para_campo_vacio}"
        end
      end

      context 'sin demandado' do
        let(:parametros) do
          {
              id: expediente.id,
              expediente: attributes_for(:expediente, demandado: ''),
              cliente_id: cliente.id,
          }
        end

        it 'devuelve un mensaje de error y bad_request' do
          subject

          expect(response).to have_http_status(:bad_request)
          expect(flash[:error]).to include "Demandado #{Expediente.mensaje_de_error_para_campo_vacio}"
        end
      end

      context 'sin materia' do
        let(:parametros) do
          {
              id: expediente.id,
              expediente: attributes_for(:expediente, materia: ''),
              cliente_id: cliente.id,
          }
        end

        it 'devuelve un mensaje de error y bad_request' do
          subject

          expect(response).to have_http_status(:bad_request)
          expect(flash[:error]).to include "Materia #{Expediente.mensaje_de_error_para_campo_vacio}"
        end
      end
    end
  end

  describe '#delete' do
    subject { delete :destroy, params: { id: expediente.id,  cliente_id: cliente.id } }

    it 'devuelve un mensaje de confirmación y redirecciona al usuario a la vista del cliente' do
      subject

      expect(flash[:success]).to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente
      assert_redirected_to cliente_url(cliente.id)
      expect(response).to have_http_status(:found)
      expect(Expediente.all.count).to eq 0
    end

    context 'no se puede eliminar un expediente que no pertenece al abogado logeado' do

      it 'devuelve un mensaje de error y bad request' do
        sign_out abogado
        abogada_logeada

        subject

        expect(flash[:error]).to include ad_hoc.mensaje_de_error_para_expediente_inexistente
        expect(response).to have_http_status(:bad_request)
        expect(Expediente.all.count).to eq 1
      end
    end
  end

  describe '#realizar_numeraracion' do
    subject do
      post :realizar_numeraracion,
           params: {
               id: expediente.id,
               cliente_id: cliente.id,
               expediente: parametros
           }
    end

    context 'En la correcta numeracion de un Expediente' do
      let(:parametros){attributes_for(:expediente_numerado)}

      it 'devuelve mensaje de confirmación y estado ok, redirecciona a la vista del expediente' do
        subject

        expect(response).to have_http_status(:ok)
        assert_template :show
        expect(flash[:success]).to eq ad_hoc.mensaje_de_confirmacion_para_la_correcta_numeracion_de_un_expediente
      end

      context 'no puede ser numerado dos veces' do

        it 'devuelve un mensaje de error y bad request, te deja en la vista de numerar expediente' do
          post :realizar_numeraracion, params: { id: expediente.id, cliente_id: cliente.id, expediente: attributes_for(:expediente_numerado)}

          subject

          expect(response).to have_http_status(:bad_request)
          assert_template :numerar
          expect(flash[:error]).to include expediente.mensaje_de_error_expediente_numerado
        end
      end
    end

    context 'En la incorrecta numeracion de un Expediente' do
      let(:parametros){ attributes_for(:expediente_numerado, actor: '') }

      it 'si falta un dato devuelve mensaje de error y bad_request, te deja en al vista de numerar expediente' do
        subject

        expect(response).to have_http_status(:bad_request)
        assert_template :numerar
        expect(flash[:error]).to include expediente.mensaje_de_error_datos_faltantes_para_numerar
        asertar_que_el_expediente_no_fue_numerado
      end
    end
  end
end
