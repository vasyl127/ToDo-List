class Cost < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }
  validates :title, numericality: { only_integer: true }
  belongs_to :project
end
