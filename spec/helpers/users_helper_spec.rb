# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersHelper do
  let(:user) { instance_double(User, user_roles_names: %w[admin doctor health_coach]) }

  describe '#user_roles_list_as_string' do
    context 'when the user has valid roles' do
      it 'returns a comma-separated string of role names' do
        result = helper.user_roles_list_as_string(user)
        expect(result).to eq('Admin, Doctor, Health coach')
      end
    end

    context 'when the user has no roles' do
      let(:user) { instance_double(User, user_roles_names: []) }

      it 'returns an empty string' do
        result = helper.user_roles_list_as_string(user)
        expect(result).to eq('')
      end
    end

    context 'when the user has invalid roles' do
      let(:user) { instance_double(User, user_roles_names: %w[invalid_role]) }

      it 'returns an empty string for invalid roles' do
        result = helper.user_roles_list_as_string(user)
        expect(result).to eq('')
      end
    end
  end

  describe '#user_role_ids_list' do
    context 'when the user has roles' do
      it 'returns the list of role names' do
        result = helper.user_role_names_list(user)
        expect(result).to eq(%w[admin doctor health_coach])
      end
    end

    context 'when the user has no roles' do
      let(:user) { instance_double(User, user_roles_names: []) }

      it 'returns an empty array' do
        result = helper.user_role_names_list(user)
        expect(result).to eq([])
      end
    end

    context 'when the user has invalid roles' do
      let(:user) { instance_double(User, user_roles_names: %w[invalid_role]) }

      it 'returns the invalid roles as-is' do
        result = helper.user_role_names_list(user)
        expect(result).to eq(['invalid_role'])
      end
    end
  end

  describe '#assigned_user_list_as_string' do
    let(:user_for_list) { instance_double(User, assigned_users: [instance_double(User, full_name: 'John Doe')]) }

    context 'when the user has assigned users' do
      it 'returns a comma-separated string of assigned user full names' do
        result = helper.assigned_user_list_as_string(user_for_list)
        expect(result).to eq('John Doe')
      end
    end

    context 'when the user has no assigned users' do
      let(:user_for_list) { instance_double(User, assigned_users: []) }

      it 'returns an empty string' do
        result = helper.assigned_user_list_as_string(user_for_list)
        expect(result).to eq('')
      end
    end
  end

  describe '#assigned_user_ids_list' do
    let(:user_assigning) { instance_double(User, assigned_users_ids: [1, 2, 3]) }

    context 'when the user has assigned users' do
      it 'returns the list of assigned user IDs' do
        result = helper.assigned_user_ids_list(user_assigning)
        expect(result).to eq([1, 2, 3])
      end
    end

    context 'when the user has no assigned users' do
      let(:user_assigning) { instance_double(User, assigned_users_ids: []) }

      it 'returns an empty array' do
        result = helper.assigned_user_ids_list(user_assigning)
        expect(result).to eq([])
      end
    end
  end

  describe '#users_list_for_select' do
    let(:user_one) { instance_double(User, full_name: 'John Doe', id: 1) }
    let(:user_two) { instance_double(User, full_name: 'Jane Doe', id: 2) }
    let(:user_list) { instance_double(User, users_list: [user_one, user_two]) }

    describe '#users_list_for_select' do
      it 'returns a list of arrays with user names and IDs for select' do
        result = helper.users_list_for_select(user_list)
        expect(result).to eq([['John Doe', 1], ['Jane Doe', 2]])
      end
    end
  end

  describe '#assigned_users_list_for_select' do
    let(:current_user) { instance_double(User, full_name: 'Current User', id: 999) }
    let(:user_with_assigned_users) do
      instance_double(
        User,
        assigned_users: [
          instance_double(User, full_name: 'Alice Johnson', id: 101),
          instance_double(User, full_name: 'Bob Smith', id: 102)
        ]
      )
    end
    let(:user_with_assigned_users_and_current) do
      instance_double(
        User,
        assigned_users: [
          instance_double(User, full_name: 'Alice Johnson', id: 101),
          instance_double(User, full_name: 'Bob Smith', id: 102),
          instance_double(User, full_name: 'Current User', id: 999)
        ]
      )
    end

    context 'when the user has assigned users and no current' do
      it 'returns a list of arrays with user names and IDs for select' do
        result = helper.assigned_users_list_for_select(user_with_assigned_users, current_user)
        expect(result).to eq([['Alice Johnson', 101], ['Bob Smith', 102], ['Current User', 999]])
      end
    end

    context 'when the user has assigned users with current' do
      it 'returns a list of arrays with user names and IDs for select' do
        result = helper.assigned_users_list_for_select(user_with_assigned_users_and_current, current_user)
        expect(result).to eq([['Alice Johnson', 101], ['Bob Smith', 102], ['Current User', 999]])
      end
    end

    context 'when the user has no assigned users' do
      let(:user_with_no_assigned_users) { instance_double(User, assigned_users: []) }

      it 'returns an empty array' do
        result = helper.assigned_users_list_for_select(user_with_no_assigned_users, current_user)
        expect(result).to eq([])
      end
    end
  end
end
