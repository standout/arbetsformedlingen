# frozen_string_literal: true

require 'csv'

module Arbetsformedlingen
  class OccupationCode
    CSV.read(
      File.expand_path('../../../data/occupation-codes.csv', __dir__)
    ).tap do |lines|
      CATEGORIES = lines.each_with_object({}) do |(code, name, category), hash|
        hash[category] ||= []
        hash[category] << name
      end.freeze

      CODES_MAP_INVERTED = lines.map { |line| line.take(2) }.to_h.freeze
      CODE_MAP = CODES_MAP_INVERTED.invert.freeze
    end

    def self.to_code(name)
      normalized = normalize(name)
      CODE_MAP.fetch(normalized) do
        normalized if CODES_MAP_INVERTED[normalized]
      end
    end

    def self.valid?(name)
      !to_code(name).nil?
    end

    def self.normalize(name)
      name.to_s.strip
    end

    def self.to_form_array(name_only: false)
      return CODE_MAP.to_a unless name_only

      CODE_MAP.map { |name, _code| [name, name] }
    end
  end
end
