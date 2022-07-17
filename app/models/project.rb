# frozen_string_literal: true

class Project < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }

  has_many :user_projects, dependent: :destroy
  has_many :users, through: :user_projects
  has_many :costs, dependent: :destroy
end
