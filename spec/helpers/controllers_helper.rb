module ControllersHelper
  include ::RSpec::Matchers
  include FactoryBot::Syntax::Methods

  def abogado_logeado
    abogado = create(:abogado)
    sign_in abogado
    abogado
  end


  def asertar_que_se_muestra_un_mensaje_de_confirmacion(un_mensaje)
    expect(flash[:success]).to eq un_mensaje
  end

  def asertar_que_se_muestra_un_mensaje_de_error(un_mensaje)
    expect(flash[:error]).to eq un_mensaje
  end

  def asertar_que_se_incluye_un_mensaje_de_error(un_mensaje)
    expect(flash[:error]).to include un_mensaje
  end

  def asertar_que_la_respuesta_tiene_estado(una_response, un_estado)
    expect(una_response).to have_http_status(un_estado)
  end

  def asertar_que_se_redirecciono_a(url)
    assert_redirected_to url
  end

  def asertar_que_el_template_es(template)
    assert_template template
  end
end
