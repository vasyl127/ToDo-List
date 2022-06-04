class Task < ApplicationRecord
  validates :name, presence: true, length: { minimum: 5 }

  belongs_to :user
end
