require 'rails_helper'

RSpec.describe ReferenceRange, type: :model do
  biomarker = FactoryBot.create(:biomarker)
  subject {
    ReferenceRange.new(
      biomarker: biomarker,
      min_value: 70.0,
      max_value: 99.0,
      unit: 'mg/dL',
      source: "DILA"
    )
  }
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a min_value" do
    subject.min_value = nil
    expect(subject).to_not be_valid
  end
  it "is not valid with non-numeric min_value" do
    subject.min_value = 'test'
    expect(subject).to_not be_valid
  end
  it "is not valid without a max_value" do
    subject.max_value = nil
    expect(subject).to_not be_valid
  end
  it "is not valid with non-numeric max_value" do
    subject.max_value = 'test'
    expect(subject).to_not be_valid
  end
  it "is not valid without a unit" do
    subject.unit = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a source" do
    subject.source = nil
    expect(subject).to_not be_valid
  end
end
