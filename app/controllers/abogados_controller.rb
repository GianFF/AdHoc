class AbogadosController < Devise::RegistrationsController
  before_action :configurar_parametros_para_crear_cuenta, only: [:create]
  before_action :configurar_parametros_para_editar_la_cuenta, only: [:update]

  def update
    validar_contrasenia do
      redirect_to root_path and return
    end
    super
  end

  def mensaje_de_error_para_contrasenia_invalida
    'La contraseña es incorrecta'
  end

  def mensaje_de_error_para_contrasenia_no_proveida
    'Debes completar tu contraseña actual para poder editar tu perfil'
  end

  protected

  def configurar_parametros_para_crear_cuenta
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido, :sexo])
  end

  def configurar_parametros_para_editar_la_cuenta
    devise_parameter_sanitizer.permit(:account_update, keys: [:nombre, :apellido, :email])
  end

  private

  def la_contrasenia_es_valida?
    @abogado.valid_password? params[:abogado][:current_password]
  end

  def la_contrasenia_es_blanca?
    params[:abogado][:current_password].blank?
  end

  def validar_contrasenia(&block)
    validar_que_la_contrasenia_no_sea_blanca do
      block.call
    end

    validar_que_la_contrasenia_no_sea_invalida do
      block.call
    end
  end

  def validar_que_la_contrasenia_no_sea_invalida(&block)
    unless la_contrasenia_es_valida?
      flash[:error] = mensaje_de_error_para_contrasenia_invalida
      block.call
    end
  end

  def validar_que_la_contrasenia_no_sea_blanca(&block)
    if la_contrasenia_es_blanca?
      flash[:error] = mensaje_de_error_para_contrasenia_no_proveida
      block.call
    end
  end
end
