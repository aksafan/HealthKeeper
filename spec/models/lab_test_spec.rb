# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabTest do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:biomarker) }
    it { is_expected.to belong_to(:recordable) }
    it { is_expected.to belong_to(:reference_range) }
  end

  describe 'validations' do
    subject(:lab_test) { build(:lab_test) }

    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:unit) }

    context 'when validating value' do
      it 'is invalid with a negative value' do
        lab_test.value = -1
        expect(lab_test).not_to be_valid
      end

      it 'has correct error message for negative value' do
        lab_test.value = -1
        lab_test.valid?
        expect(lab_test.errors[:value]).to include('must be both nonnegative and numeric')
      end

      it 'is invalid with non-numeric value' do
        lab_test.value = 'abc'
        expect(lab_test).not_to be_valid
      end

      it 'has correct error message for non-numeric value' do
        lab_test.value = 'abc'
        lab_test.valid?
        expect(lab_test.errors[:value]).to include('must be both nonnegative and numeric')
      end
    end
  end
end
