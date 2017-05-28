class EscritosController < ApplicationController
  attr_reader :escrito

  def new
    new_escrito_expediente_y_cliente
  end

  def show
    begin
      show_escrito_expediente_y_cliente
    rescue AdHocUIError => error
      mostrar_errores(error.adhoc_error)
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    begin
      @escrito = @ad_hoc.crear_escrito_nuevo!(validar_parametros_escrito, validar_parametros_expediente, abogado_actual)
      buscar_expediente_y_cliente_para_escrito
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_escrito
      render :show
    rescue AdHocUIError => error
      mostrar_errores(error.adhoc_error)
      new_escrito_expediente_y_cliente
      render :new
    end
  end

  def update
    begin
      @escrito = @ad_hoc.editar_escrito!(params[:id], validar_parametros_escrito, abogado_actual)
      buscar_expediente_y_cliente_para_escrito
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_escrito
    rescue AdHocUIError => error
      mostrar_errores(error.adhoc_error)
      show_escrito_expediente_y_cliente
    end
    render :show
  end

  def destroy
    @ad_hoc.eliminar_escrito!(params[:id], abogado_actual)
    flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_escrito
    redirect_to expediente_url(validar_parametros_expediente)
  end

  private

  def new_escrito_expediente_y_cliente
    @escrito = Escrito.new
    @expediente = @ad_hoc.buscar_expediente_por_id!(validar_parametros_expediente, abogado_actual)
    @cliente = @expediente.cliente
  end

  def show_escrito_expediente_y_cliente
    @escrito = @ad_hoc.buscar_escrito_por_id!(params[:id], abogado_actual)
    buscar_expediente_y_cliente_para_escrito
  end

  def buscar_expediente_y_cliente_para_escrito
    @expediente = @escrito.expediente
    @cliente = @expediente.cliente
  end

  def validar_parametros_escrito
    params.require(:escrito).permit(:cuerpo, :titulo)
  end

  def validar_parametros_expediente
    params.require(:expediente_id)
  end
end
