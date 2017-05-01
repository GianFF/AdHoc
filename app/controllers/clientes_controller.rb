class ClientesController < ApplicationController
  before_action :authenticate_abogado!
  attr_reader :cliente

  def show
    begin
      @cliente = Cliente.where(["id = ? and abogado_id = ?", params[:id], current_abogado.id]).take!
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = "Cliente inexistente"
    end
  end

  def new
    @cliente = Cliente.new
  end

  def edit
    begin
      @cliente = Cliente.where(["id = ? and abogado_id = ?", cliente_id, current_abogado.id]).take!
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = "Cliente inexistente"
    end
  end

  def create
    begin
      @cliente = Cliente.new(validar_parametros_cliente)
      @cliente.abogado = current_abogado
      @cliente.save!
      flash.now[:success] = 'Cliente creado satisfactoriamente'
      render :show
    rescue  ActiveRecord::RecordInvalid
      @cliente = nil
      flash.now[:error] = 'El nombre y el apellido no pueden ser vacios'
      render :new
    end
  end

  def update
    @cliente = Cliente.find(cliente_id)
    begin
      @cliente.update!(validar_parametros_cliente)
    rescue ActiveRecord::ActiveRecordError
      flash.now[:error] = 'El nombre y el apellido no pueden ser vacios'
      redirect_to action: :edit, status: :bad_request and return
    end
      flash.now[:success] = 'Cliente editado satisfactoriamente'
      render :show
  end

  def destroy
    begin
      @cliente = Cliente.where(["id = ? and abogado_id = ?", params[:id], current_abogado.id]).take!
      @cliente.destroy
      flash.now[:success] = "Cliente eliminado satisfactoriamente"
      @cliente = nil
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = "Cliente inexistente"
    end
    render :new
  end

  def buscar
    begin
      @cliente = Cliente.where(["nombre = ? and abogado_id = ?", params.require(:nombre), current_abogado.id]).take!
      render :js => "window.location = '/clientes/#{@cliente.id}'"
    rescue ActiveRecord::RecordNotFound
      flash.now[:error] = "No se encontraron clientes con nombre: #{params[:nombre]}"
      render :js => "window.location = '/'", status: :not_found
    end
  end

  private
  def validar_parametros_cliente
    params.require(:cliente).permit(:nombre, :apellido, :correo_electronico, :telefono, :estado_civil,
                                    :empresa, :esta_en_blanco)
  end

  # TODO: eliminar cuanto antes este parche.
  # Entender porque en el form de edicion viene el ID delcliente como format en vez de como id
  def cliente_id
    params[:format] || params[:id]
  end
end
