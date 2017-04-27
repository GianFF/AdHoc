class AbogadosController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    unless params[:abogado][:current_password].blank?

      unless @abogado.valid_password?(params[:abogado][:current_password])
        flash[:error] = mensaje_de_error_para_contrasenia_invalida
        redirect_to root_path
      else
        super
      end
    else
      flash[:error] = mensaje_de_error_para_contrasenia_no_proveida
      redirect_to root_path
    end
  end

  def mensaje_de_error_para_contrasenia_invalida
    'La contraseña es incorrecta'
  end

  def mensaje_de_error_para_contrasenia_no_proveida
    'Debes completar tu contraseña actual para poder editar tu perfil'
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido, :sexo])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:nombre, :apellido, :email])
  end
end
