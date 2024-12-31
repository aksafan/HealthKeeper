# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::UsersController' do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:valid_attributes) { { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com' } }
  let(:invalid_attributes) { { email: '' } }
  let(:roles) { %w[admin doctor user] }

  before do
    sign_in admin
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get admin_users_path
      expect(response).to be_successful
    end

    it 'authorizes and displays all users' do
      users_amount = 3
      create_list(:user, users_amount)
      get admin_users_path
      expect(assigns(:users).count).to eq(users_amount + 1) # Include the admin user
    end
  end

  describe 'GET /show' do
    it 'renders the user details' do
      get admin_user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders the edit form' do
      get edit_admin_user_path(user)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      it 'redirects to the user page' do
        patch admin_user_path(user), params: { user: valid_attributes }
        expect(response).to redirect_to(admin_user_path(user))
      end

      it 'updates the user attributes' do
        patch admin_user_path(user), params: { user: valid_attributes }
        expect(user.reload.first_name).to eq('John')
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit form with errors' do
        patch admin_user_path(user), params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes the user' do
      user_to_delete = create(:user)
      expect do
        delete admin_user_path(user_to_delete)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users index' do
      user_to_delete = create(:user)
      delete admin_user_path(user_to_delete)
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'GET /edit_roles' do
    it 'renders the edit roles form' do
      get edit_roles_admin_user_path(user)
      expect(response).to be_successful
    end

    it 'assigns roles list' do
      roles.each { |role| Role.find_or_create_by!(name: role) } # Prevent duplicate role creation
      get edit_roles_admin_user_path(user)
      expect(assigns(:roles)).to match_array(roles.map { |r| [r.capitalize, r] })
    end
  end

  describe 'POST /update_roles' do
    context 'with valid roles' do
      it 'redirects to the user page' do
        roles.each { |role| Role.find_or_create_by!(name: role) }
        post update_roles_admin_user_path(user), params: { user: { roles: %w[admin doctor] } }
        expect(response).to redirect_to(admin_user_path(user))
      end

      it 'updates the user roles' do
        roles.each { |role| Role.find_or_create_by!(name: role) }
        post update_roles_admin_user_path(user), params: { user: { roles: %w[admin doctor] } }
        expect(user.reload.roles.map(&:name)).to include('admin', 'doctor')
      end
    end

    context 'with invalid roles' do
      it 'returns an unprocessable entity status' do
        post update_roles_admin_user_path(user), params: { user: { roles: %w[invalid_role] } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns errors to the user object' do
        post update_roles_admin_user_path(user), params: { user: { roles: %w[invalid_role] } }
        expect(assigns(:user).errors[:base]).to include('Invalid roles detected: invalid_role')
      end
    end
  end
end
