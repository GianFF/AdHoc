class AbogadosController < Devise::RegistrationsController
  before_action :configurar_parametros_para_crear_cuenta, only: [:create]

  def create
    super do
      errores = resource.errors.full_messages
      mostrar_errores(Errores::AdHocDomainError.new(errores)) if errores.length > 0
    end
  end

  def update
    begin
      @abogado = AdHocAbogados.new.editar_abogado!(@abogado, validar_parametros_abogado)
      flash.keep[:success] = 'Perfil editado satisfactoriamente'
    rescue Errores::AdHocDomainError => error
      mostrar_errores(error, mantener_error: true)
    end
    redirect_to root_path
  end

  protected

  def configurar_parametros_para_crear_cuenta
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido, :genero, :email, :matricula,
                                                       :nombre_del_colegio_de_abogados, :cuit, :domicilio_procesal,
                                                       :domicilio_electronico])
  end

  def validar_parametros_abogado
    params.require(:abogado).permit(:nombre, :apellido, :email, :matricula, :nombre_del_colegio_de_abogados, :cuit,
                                    :domicilio_procesal, :domicilio_electronico, :encrypted_password, :password)
  end
end
