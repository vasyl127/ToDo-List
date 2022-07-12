class Project < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }

  has_many :user_projects
  has_many :users, through: :user_projects
  has_many :costs
end
