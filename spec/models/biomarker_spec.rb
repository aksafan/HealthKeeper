require 'rails_helper'

RSpec.describe Biomarker do
  subject(:biomarker) {
    described_class.new(
      name: "C-Reactive Protein"
    )
  }

  it "is valid with valid attributes" do
    expect(biomarker).to be_valid
  end

  it "is not valid without a name" do
    biomarker.name = nil
    expect(biomarker).not_to be_valid
  end
end
