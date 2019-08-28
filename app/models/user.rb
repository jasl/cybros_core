# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable,
         :registerable, :lockable, :invitable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable

  scope :active, -> { where(locked_at: nil) }

  def admin?
    email.in? Settings.admin.emails
  end

  include DeviseFailsafe
end
