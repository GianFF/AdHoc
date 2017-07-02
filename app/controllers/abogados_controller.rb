class AbogadosController < Devise::RegistrationsController
  before_action :configurar_parametros_para_crear_cuenta, only: [:create]

  def create
    super do
      errores = resource.errors.full_messages
      mostrar_errores(AdHocUIExcepcion.new(errores)) if errores.length > 0
    end
  end

  def update
    begin
      @ad_hoc.validar_contrasenia(params[:abogado][:current_password], @abogado)
      @abogado = @ad_hoc.editar_abogado!(@abogado, validar_parametros_abogado)
      flash.keep[:success] = 'Perfil editado satisfactoriamente'
      redirect_to root_path
    rescue AdHocUIExcepcion => error
      respond_to do |format|
        format.json { render plain: error.errores, status: :found }
      end
    end
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
