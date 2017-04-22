class Abogado < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :timeoutable, :lockable

  validates :nombre,   presence: true
  validates :apellido, presence: true
  validates :sexo,     presence: true
end