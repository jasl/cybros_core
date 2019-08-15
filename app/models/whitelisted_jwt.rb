# frozen_string_literal: true

class WhitelistedJwt < ApplicationRecord
  belongs_to :user
end
