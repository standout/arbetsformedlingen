# frozen_string_literal: true

require 'date'
require 'time'
require 'arbetsformedlingen/api/request'
require 'arbetsformedlingen/api/results/matchning_criteria_result'

module Arbetsformedlingen
  module API
    # API client for matchning
    class MatchningCriteriaClient
      BASE_URL = 'https://www.arbetsformedlingen.se/rest/matchning/rest/af/v1/matchning/matchningskriterier/'.freeze

      attr_reader :request

      # Initialize client
      def initialize(request: Request.new(base_url: BASE_URL))
        @request = request
      end

      def occupation_categories
        response = request.get('yrkesomraden')

        MatchningCriteriaResult.build(response)
      end

      def occupation_groups(category_id)
        query = { gruppid: category_id }

        response = request.get('yrkesgrupper', query: query)

        MatchningCriteriaResult.build(response)
      end

      def occupations(group_id)
        query = { gruppid: group_id }

        response = request.get('yrken', query: query)

        MatchningCriteriaResult.build(response)
      end
    end
  end
end
