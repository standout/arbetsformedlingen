# frozen_string_literal: true

module Arbetsformedlingen
  module API
    module Values
      MatchningCriteria = KeyStruct.new(
        :id,
        :name,
        :type
      )
    end
  end
end
