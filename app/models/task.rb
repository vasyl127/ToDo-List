# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { minimum: 5 }

  belongs_to :user
end
