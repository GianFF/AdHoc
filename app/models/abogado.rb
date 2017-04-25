class Abogado < ApplicationRecord
  has_many :clientes
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :timeoutable, :lockable

  validates :nombre,   presence: true
  validates :apellido, presence: true
  validates :sexo,     presence: true
  validates :email, uniqueness: true

  def tu_email_es?(un_email)
    self.email  == un_email
  end
end
