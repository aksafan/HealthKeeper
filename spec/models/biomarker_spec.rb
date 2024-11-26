# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Biomarker do
  subject(:biomarker) do
    described_class.new(
      name: 'C-Reactive Protein'
    )
  end

  it 'is valid with valid attributes' do
    expect(biomarker).to be_valid
  end

  it 'is not valid without a name' do
    biomarker.name = nil
    expect(biomarker).not_to be_valid
  end
end
