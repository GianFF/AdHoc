module ControllersHelper
  include ::RSpec::Matchers
  include FactoryBot::Syntax::Methods

  def abogado_logeado
    abogado = create(:abogado)
    sign_in abogado
    abogado
  end

  def abogada_logeada
    abogada = create(:abogada)
    sign_in abogada
    abogada
  end


  def asertar_que_se_muestra_un_mensaje_de_confirmacion(un_mensaje)
    expect(flash[:success]).to eq un_mensaje
  end

  def asertar_que_se_muestra_un_mensaje_de_error(un_mensaje)
    expect(flash[:error]).to eq un_mensaje
  end


  def asertar_que_se_redirecciono_a(url)
    assert_redirected_to url
  end

  def asertar_que_el_template_es(template)
    assert_template template
  end
end
