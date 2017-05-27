module ControllersHelper
  include ::RSpec::Matchers

  def login_abogado(parametros)
    abogado = crear_cuenta_para_abogado(parametros)
    sign_in abogado
    abogado
  end

  def crear_cuenta_para_abogado(parametros)
    abogado = fabrica_de_objetos.crear_un_abogado(parametros)
    #abogado.confirm
    abogado
  end

  def asertar_que_los_datos_del_cliente_son_correctos(cliente)
    expect(cliente.nombre).to eq fabrica_de_objetos.un_nombre_para_un_cliente
    expect(cliente.apellido).to eq fabrica_de_objetos.un_apellido_para_un_cliente
  end

  def asertar_que_se_muestra_un_mensaje_de_confirmacion(un_mensaje)
    expect(flash[:success]).to eq un_mensaje
  end

  def asertar_que_se_muestra_un_mensaje_de_error(un_mensaje)
    expect(flash[:error]).to eq un_mensaje
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
