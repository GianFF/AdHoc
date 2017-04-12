class ClientesController < ApplicationController
  attr_reader :cliente

  def show
    @cliente = Cliente.find(params[:id])
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    @cliente = Cliente.find(params[:id])
  end

  def create
    begin
      @cliente = Cliente.create!(validar_parametros_cliente)
    rescue ActiveRecord::ActiveRecordError
      flash[:error] = 'Faltan datos para poder crear el cliente'
    else
      flash[:success] = 'Cliente creado satisfactoriamente'
    ensure
      render :show
    end
  end

  def update
    @cliente = Cliente.find(params[:id])
    begin
      @cliente.update!(validar_parametros_cliente)
    rescue ActiveRecord::ActiveRecordError
      flash[:error] = 'El nombre y el apellido no pueden ser vacios'
      redirect_to action: :edit, status: :bad_request and return
    end
      flash[:success] = 'Cliente editado satisfactoriamente'
      render :show
  end

  def destroy
    Cliente.find(params[:id]).destroy

    flash[:success] = "Cliente eliminado satisfactoriamente"
    render :new
  end

  def buscar
    @cliente = Cliente.find_by_nombre(params.require(:nombre))

    render :js => "window.location = '/clientes/#{@cliente.id}'" and return if @cliente

    flash[:error] = "No se encontraron clientes con nombre: #{params[:nombre]}"
    render :js => "window.location = '/'", status: :not_found
  end

  private
  def validar_parametros_cliente
    params.require(:cliente).permit(:nombre, :apellido, :correo_electronico, :telefono, :estado_civil,
                                    :empresa, :esta_en_blanco)
  end
end
