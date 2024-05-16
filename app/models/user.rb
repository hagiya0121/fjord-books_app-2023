# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :icon

  validates :icon, attached: true, content_type: ['image/jpg', 'image/png', 'image/gif']
end
