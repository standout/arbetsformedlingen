# frozen_string_literal: true

require 'arbetsformedlingen/api/values/matchning_criteria_result_values'

module Arbetsformedlingen
  module API
    module MatchningCriteriaResult
      def self.build(response)
        response.json.map do |result|
          Values::MatchningCriteria.new(
            id: result.fetch("id"),
            name: result.fetch("namn"),
            type: result.fetch("typ"),
          )
        end
      end
    end
  end
end
