# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::UsersController' do
  let(:roles) { %w[admin doctor user] }
  let(:user) { create(:user, :user_role) }
  let(:doctor) { create(:user, :doctor_role) }

  before { sign_in create(:user, :admin_role) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get admin_users_path
      expect(response).to be_successful
    end

    it 'authorizes and displays all users' do
      create_list(:user, 3)
      get admin_users_path
      expect(assigns(:users).count).to eq(4) # 3 created + 1 admin
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
      let(:valid_attributes) { { first_name: 'John', last_name: 'Doe', email: 'john.doe@example.com' } }

      it 'updates the user attributes' do
        patch admin_user_path(user), params: { user: valid_attributes }
        expect(user.reload.first_name).to eq('John')
      end

      it 'redirects to the user page' do
        patch admin_user_path(user), params: { user: valid_attributes }
        expect(response).to redirect_to(admin_user_path(user))
      end

      it 'sets the flash notice message' do
        patch admin_user_path(user), params: { user: valid_attributes }
        expect(flash[:notice]).to eq(t('admin.users.update.success'))
      end
    end

    context 'with invalid parameters' do
      it 'renders the edit form with errors' do
        patch admin_user_path(user), params: { user: { email: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:user_to_delete) { create(:user) }
    let(:user_to_delete_and_redirect) { create(:user) }

    it 'deletes the user' do
      user_to_delete
      expect { delete admin_user_path(user_to_delete) }.to change(User, :count).by(-1)
    end

    it 'redirects to the index' do
      user_to_delete_and_redirect
      delete admin_user_path(user_to_delete)
      expect(response).to redirect_to(admin_users_path)
    end

    it 'sets the flash notice message' do
      user_to_delete_and_redirect
      delete admin_user_path(user_to_delete)
      expect(flash[:notice]).to eq(t('admin.users.destroy.success'))
    end
  end

  describe 'GET /edit_roles' do
    it 'renders the edit roles form' do
      get edit_roles_admin_user_path(user)
      expect(assigns(:roles)).to match_array(roles.map { |r| [r.capitalize, r] })
    end
  end

  describe 'POST /update_roles' do
    context 'with valid roles' do
      it 'updates the roles' do
        post update_roles_admin_user_path(user), params: { user: { roles: %w[admin doctor] } }
        expect(user.reload.roles.map(&:name)).to include('admin', 'doctor')
      end

      it 'redirects to the user page' do
        post update_roles_admin_user_path(user), params: { user: { roles: %w[admin doctor] } }
        expect(response).to redirect_to(admin_user_path(user))
      end

      it 'sets the flash notice message' do
        post update_roles_admin_user_path(user), params: { user: { roles: %w[admin doctor] } }
        expect(flash[:notice]).to eq(t('admin.users.update_roles.success'))
      end
    end

    context 'with invalid roles' do
      let(:invalid_roles) { %w[invalid_role] }

      it 'returns an unprocessable entity status' do
        post update_roles_admin_user_path(user), params: { user: { roles: invalid_roles } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns errors' do
        post update_roles_admin_user_path(user), params: { user: { roles: invalid_roles } }
        expect(assigns(:user).errors[:base]).to include('Invalid roles detected: invalid_role')
      end
    end

    context 'with empty roles' do
      let(:empty_roles) { [] }

      it 'returns an unprocessable entity status' do
        post update_roles_admin_user_path(user), params: { user: { roles: empty_roles } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns errors' do
        post update_roles_admin_user_path(user), params: { user: { roles: empty_roles } }
        expect(assigns(:user).errors[:base]).to include('You can not leave user without any role')
      end
    end
  end

  describe 'GET /edit_assigned_users' do
    subject(:users_to_assign) { create_list(:user, 3) }

    it 'renders the edit assigned users form' do
      users_to_assign.each do |assigned_user|
        doctor.assigned_users << assigned_user
      end

      get edit_assigned_users_admin_user_path(doctor)
      expect(assigns(:user).assigned_users).to match_array(users_to_assign)
    end

    it 'authorizes the user to edit assigned users' do
      expect do
        get edit_assigned_users_admin_user_path(doctor)
      end.not_to raise_error
    end
  end

  describe 'POST /update_assigned_users' do
    subject(:users_to_assign) { create_list(:user, 3) }

    context 'with valid user IDs' do
      let(:valid_user_ids) { users_to_assign.map(&:id) }

      it 'redirects to the user page' do
        post update_assigned_users_admin_user_path(doctor), params: { user: { users: valid_user_ids } }
        expect(response).to redirect_to(admin_user_path(doctor))
      end

      it 'updates the assigned users' do
        post update_assigned_users_admin_user_path(doctor), params: { user: { users: valid_user_ids } }
        expect(doctor.reload.assigned_users.pluck(:id)).to match_array(valid_user_ids)
      end

      it 'removes the current user from the session if needed' do
        inject_session(user_id: users_to_assign.first.id) do
          post update_assigned_users_admin_user_path(doctor), params: { user: { users: valid_user_ids[1..] } }
          expect(request.session[:user_id]).to be_nil
        end
      end

      it 'does not remove the current user from the session if they are still assigned' do
        inject_session(user_id: users_to_assign.first.id) do
          post update_assigned_users_admin_user_path(doctor), params: { user: { users: valid_user_ids } }
          expect(request.session[:user_id]).to eq(users_to_assign.first.id)
        end
      end
    end

    context 'with invalid user IDs' do
      let(:invalid_user_ids) { [99_999, 100_000] }

      it 'returns an unprocessable entity status' do
        post update_assigned_users_admin_user_path(doctor), params: { user: { users: invalid_user_ids } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'assigns errors' do
        post update_assigned_users_admin_user_path(doctor), params: { user: { users: invalid_user_ids } }
        expect(assigns(:user).errors[:base]).to include('Unexpected error while updating user')
      end
    end
  end

  describe 'POST /switch_user' do
    let(:target_user) { create(:user) }

    context 'when a valid user_id is provided' do
      it 'sets the session user_id to the provided user_id' do
        post switch_user_admin_user_path(target_user),
             params: { user_id: target_user.id },
             headers: { 'HTTP_REFERER' => admin_users_path }
        expect(session[:user_id]).to eq(target_user.id)
      end

      it 'redirects back to the referer' do
        post switch_user_admin_user_path(target_user),
             params: { user_id: target_user.id },
             headers: { 'HTTP_REFERER' => admin_users_path }
        expect(response).to redirect_to(admin_users_path)
      end

      it 'sets the flash notice message' do
        post switch_user_admin_user_path(target_user),
             params: { user_id: target_user.id },
             headers: { 'HTTP_REFERER' => admin_users_path }
        expect(flash[:notice]).to eq(t('admin.users.switch_user.success'))
      end
    end

    context 'when no user_id is provided' do
      it 'does not set the session user_id' do
        post switch_user_admin_user_path(target_user), headers: { 'HTTP_REFERER' => admin_users_path }
        expect(session[:user_id]).to be_nil
      end

      it 'redirects back to the referer' do
        post switch_user_admin_user_path(target_user), headers: { 'HTTP_REFERER' => admin_users_path }
        expect(response).to redirect_to(admin_users_path)
      end

      it 'sets the flash alert message' do
        post switch_user_admin_user_path(target_user), headers: { 'HTTP_REFERER' => admin_users_path }
        expect(flash[:alert]).to eq(t('admin.users.switch_user.failure'))
      end
    end
  end
end
