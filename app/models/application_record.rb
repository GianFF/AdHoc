class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def subclass_responsibility
    raise StandardError, 'Subclass responsibility'
  end
end
