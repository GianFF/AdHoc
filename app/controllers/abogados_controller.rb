class AbogadosController < Devise::RegistrationsController
  before_action :configurar_parametros_para_crear_cuenta, only: [:create]

  def create
    super do
      errores = resource.errors.full_messages.map { |msg| "<li>#{msg}</li>" }.join
      flash.now[:error] = errores.html_safe if errores.length > 0
    end
  end

  def update
    begin
      @ad_hoc.validar_contrasenia(params[:abogado][:current_password], @abogado) do |mensaje_de_error|
        flash[:error] = mensaje_de_error
        redirect_to root_path and return
      end
      @abogado = @ad_hoc.editar_abogado!(@abogado, validar_parametros_abogado)
      flash.keep[:success] = 'Perfil editado satisfactoriamente'
    rescue AdHocUIExcepcion => error
      mostrar_errores(error, with_keep: true)
    end
    redirect_to root_path
  end

  protected

  def configurar_parametros_para_crear_cuenta
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido, :sexo, :email, :matricula,
                                                       :nombre_del_colegio_de_abogados, :cuit, :domicilio_procesal,
                                                       :domicilio_electronico])
  end

  def configurar_parametros_para_editar_la_cuenta
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: [:nombre, :apellido, :email, :matricula, :nombre_del_colegio_de_abogados,
                                             :cuit, :domicilio_procesal, :domicilio_electronico])
  end

  def validar_parametros_abogado
    params.require(:abogado).permit(:nombre, :apellido, :email, :matricula, :nombre_del_colegio_de_abogados, :cuit,
                                    :domicilio_procesal, :domicilio_electronico)
  end
end
