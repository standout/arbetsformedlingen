require 'arbetsformedlingen/api/values/soklista_values'

module Arbetsformedlingen
  module API
    module SoklistaResult
      def self.build(response, list_name: nil)
        return build_empty_page(response, list_name) unless response.success?

        build_page(response, list_name)
      end

      # private

      def self.build_empty_page(response, list_name)
        response_data = response.json
        Values::SoklistaPage.new(
          list_name: list_name,
          total_ads: 0,
          total_vacancies: 0,
          raw_data: response_data,
          data: [],
          response: response
        )
      end

      def self.build_page(response, list_name)
        response_data = response.json
        data = response_data.fetch('soklista', {})

        Values::SoklistaPage.new(
          list_name: data.fetch('listnamn', list_name),
          total_ads: data.fetch('totalt_antal_platsannonser', 0),
          total_vacancies: data.fetch('totalt_antal_ledigajobb', 0),
          raw_data: response_data,
          data: data.fetch('sokdata', []).map do |result|
            build_search_result(result)
          end,
          response: response
        )
      end

      def self.build_search_result(result)
        Values::SoklistaResult.new(
          id: result.fetch('id'),
          name: result.fetch('namn'),
          total_ads: result.fetch('antal_platsannonser'),
          total_vacancies: result.fetch('antal_ledigajobb')
        )
      end
    end
  end
end
