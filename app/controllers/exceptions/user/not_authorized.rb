# frozen_string_literal: true

module Exceptions
  module User
    # Raise me for a 401
    class NotAuthorized < StandardError
      def initialize(message = 'You are not authorized to perform this action.')
        super
      end
    end
  end
end
