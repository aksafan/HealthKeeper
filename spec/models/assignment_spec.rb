# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Assignment do
  let(:assignee) { create(:user) }
  let(:assigned_one) { create(:user) }
  let(:assigned_two) { create(:user) }

  it 'returns the assigned users for a specific assignee' do
    create(:assignment, assignee: assignee, assigned: assigned_one)
    create(:assignment, assignee: assignee, assigned: assigned_two)

    expect(assignee.assigned_users).to contain_exactly(assigned_one, assigned_two)
  end
end
