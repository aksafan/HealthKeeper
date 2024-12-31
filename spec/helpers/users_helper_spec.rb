# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersHelper do
  let(:user) { instance_double(User, user_roles_names: %w[admin doctor health_coach]) }

  describe '#get_user_roles_list_as_string' do
    context 'when the user has valid roles' do
      it 'returns a comma-separated string of role names' do
        result = helper.get_user_roles_list_as_string(user)
        expect(result).to eq('Admin, Doctor, Health coach')
      end
    end

    context 'when the user has no roles' do
      let(:user) { instance_double(User, user_roles_names: []) }

      it 'returns an empty string' do
        result = helper.get_user_roles_list_as_string(user)
        expect(result).to eq('')
      end
    end

    context 'when the user has invalid roles' do
      let(:user) { instance_double(User, user_roles_names: %w[invalid_role]) }

      it 'returns nil for invalid roles' do
        result = helper.get_user_roles_list_as_string(user)
        expect(result).to eq('')
      end
    end
  end

  describe '#get_user_role_ids_list' do
    context 'when the user has roles' do
      it 'returns the list of role IDs' do
        result = helper.get_user_role_ids_list(user)
        expect(result).to eq(%w[admin doctor health_coach])
      end
    end

    context 'when the user has no roles' do
      let(:user) { instance_double(User, user_roles_names: []) }

      it 'returns an empty array' do
        result = helper.get_user_role_ids_list(user)
        expect(result).to eq([])
      end
    end

    context 'when the user has invalid roles' do
      let(:user) { instance_double(User, user_roles_names: %w[invalid_role]) }

      it 'returns the invalid roles as-is' do
        result = helper.get_user_role_ids_list(user)
        expect(result).to eq(['invalid_role'])
      end
    end
  end
end
