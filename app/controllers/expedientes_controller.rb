class ExpedientesController < ApplicationController
  before_action :authenticate_abogado!

  def show
    begin
      buscar_expediente_escritos_y_cliente
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def new
    @expediente = Expediente.new
    @cliente = @ad_hoc.buscar_cliente_por_id!(validar_parametros_cliente, abogado_actual)
    @expediente.cliente = @cliente
  end

  def edit
    begin
      buscar_expediente_escritos_y_cliente
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def create
    begin
      @expediente = @ad_hoc.crear_expediente_nuevo!(validar_parametros_expediente, validar_parametros_cliente, abogado_actual)
      buscar_escritos_y_cliente
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_creacion_de_un_expediente
      render :show
    rescue UIExcepcion => excepcion
      mostrar_errores(excepcion)
      @expediente = Expediente.new
      @cliente = @ad_hoc.buscar_cliente_por_id!(validar_parametros_cliente, abogado_actual)
      render :new
    end
  end

  def update
    begin
      @expediente = @ad_hoc.editar_expediente!(params[:id], validar_parametros_expediente, abogado_actual)
      @cliente = @ad_hoc.buscar_cliente_por_id!(validar_parametros_cliente, abogado_actual)
      buscar_escritos
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_edicion_de_un_expediente
      render :show
    rescue UIExcepcion => excepcion
      mostrar_errores(excepcion)
      buscar_expediente_escritos_y_cliente
      render :edit, status: :bad_request
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def destroy
    begin
      @ad_hoc.eliminar_expediente!(params[:id], abogado_actual)
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_eliminacion_de_un_expediente
      redirect_to cliente_url(validar_parametros_cliente)
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def numerar
    begin
      buscar_expediente_escritos_y_cliente
      @ad_hoc.validar_que_no_haya_sido_numerado(@expediente)
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  def realizar_numeraracion
    begin
      @expediente = @ad_hoc.numerar_expediente!(validar_parametros_para_numerar_expediente, params[:id], abogado_actual)
      buscar_escritos_y_cliente
      flash.now[:success] = @ad_hoc.mensaje_de_confirmacion_para_la_correcta_numeracion_de_un_expediente
      render :show
    rescue UIExcepcion => excepcion
      mostrar_errores(excepcion)
      buscar_expediente_escritos_y_cliente
      render :numerar
    rescue HackExcepcion => excepcion
      rescue_hack_exception(excepcion)
    end
  end

  private

  def buscar_expediente_escritos_y_cliente
    @expediente = @ad_hoc.buscar_expediente_por_id!(params[:id], abogado_actual)
    buscar_escritos_y_cliente
  end

  def buscar_escritos_y_cliente
    buscar_escritos
    @cliente = @expediente.cliente
  end

  def buscar_escritos
    @escritos = @expediente.demandas || []
  end

  def validar_parametros_expediente
    params.require(:expediente).permit(:actor, :demandado, :materia, :numero, :juzgado,
                                       :numero_de_juzgado, :departamento, :ubicacion_del_departamento)
  end

  def validar_parametros_cliente
    params.require(:cliente_id)
  end

  def validar_parametros_para_numerar_expediente
    params.require(:expediente).permit(:id, :actor, :demandado, :materia, :numero, :juzgado, :numero_de_juzgado, :departamento,
                                       :ubicacion_del_departamento, :cliente_id)
  end
end
