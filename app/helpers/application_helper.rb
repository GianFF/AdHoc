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
end
