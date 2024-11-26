# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferenceRange do
  subject(:reference_range) do
    described_class.new(
      biomarker: biomarker,
      min_value: 70.0,
      max_value: 99.0,
      unit: 'mg/dL',
      source: 'DILA'
    )
  end

  let(:biomarker) { create(:biomarker) }

  it 'is valid with valid attributes' do
    expect(reference_range).to be_valid
  end

  it 'is not valid without a min_value' do
    reference_range.min_value = nil
    expect(reference_range).not_to be_valid
  end

  it 'is not valid with non-numeric min_value' do
    reference_range.min_value = 'test'
    expect(reference_range).not_to be_valid
  end

  it 'is not valid without a max_value' do
    reference_range.max_value = nil
    expect(reference_range).not_to be_valid
  end

  it 'is not valid with non-numeric max_value' do
    reference_range.max_value = 'test'
    expect(reference_range).not_to be_valid
  end

  it 'is not valid without a unit' do
    reference_range.unit = nil
    expect(reference_range).not_to be_valid
  end

  it 'is not valid without a source' do
    reference_range.source = nil
    expect(reference_range).not_to be_valid
  end
end
