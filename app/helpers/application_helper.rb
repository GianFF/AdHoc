module ApplicationHelper
  def resource_name
    :abogado
  end

  def resource
    @resource ||= current_abogado
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:abogado]
  end

  def escritos_que_no_son(un_escrito, escritos)
    escritos - [un_escrito]
  end

  def expedientes_que_no_son(un_expediente, expedientes)
    expedientes - [un_expediente]
  end
end
