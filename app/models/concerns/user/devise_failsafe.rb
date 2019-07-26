# frozen_string_literal: true

class User
  module DeviseFailsafe
    extend ActiveSupport::Concern

    # Failsafe when disabled confirmable
    def confirmed?
      if defined? super
        super
      else
        true
      end
    end

    def pending_reconfirmation?
      if defined? super
        super
      else
        false
      end
    end

    def created_by_invite?
      if defined? super
        super
      else
        false
      end
    end
  end
end
