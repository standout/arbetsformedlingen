# frozen_string_literal: true

require 'spec_helper'

require 'arbetsformedlingen/api/client'

RSpec.describe Arbetsformedlingen::API::MatchningCriteriaClient do
  describe '#occupation_categories', vcr: true do
    it 'returns a list of occupation categories' do
      client = described_class.new

      categories = client.occupation_categories

      expect(categories.size).to be(21)
    end
  end

  describe '#occupation_groups', vcr: true do
    it 'returns a list of occupation groups for a category' do
      client = described_class.new
      occupation_category_id = 3 # Data/IT

      groups = client.occupation_groups(occupation_category_id)

      expect(groups.size).to be(12)
    end
  end

  describe '#occupations', vcr: true do
    it 'returns a list of occupations' do
      client = described_class.new
      occupation_group_id = 2512 # Mjukvaru- och systemutvecklare m.fl.

      occupations = client.occupations(occupation_group_id)

      expect(occupations.size).to be(16)
    end
  end
end
