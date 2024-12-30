# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy update edit_roles update_roles]
    before_action :set_roles_list, only: %i[edit_roles update_roles]
    before_action :set_user_params_roles, only: %i[update_roles]

    # GET /admin/users or /admin/users.json
    def index
      @users = policy_scope(User.all)
    end

    # GET /admin/users/1 or /admin/users/1.json
    def show
      authorize @user
    end

    # GET /admin/users/1/edit
    def edit
      authorize @user
    end

    # PATCH/PUT /admin/users/1 or /admin/users/1.json
    def update
      authorize @user

      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_user_url(@user), notice: t('.success') }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/users/1 or /admin/users/1.json
    def destroy
      authorize @user
      @user.destroy!

      respond_to do |format|
        format.html { redirect_to admin_users_path, status: :see_other, notice: t('.success') }
        format.json { head :no_content }
      end
    end

    # GET /admin/users/1/edit_roles or /admin/users/1/edit_roles.json
    def edit_roles
      authorize @user
    end

    # POST /admin/users/1/update_roles or /admin/users/1/update_roles.json
    def update_roles
      authorize @user

      respond_to do |format|
        if @user.update_roles?(@user_params_roles)
          format.html { redirect_to admin_user_url(@user), notice: t('.success') }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit_roles, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_roles_list
      @roles = Role.distinct.pluck(:name).map { |role| [role.capitalize, role] }
    end

    def set_user_params_roles
      @user_params_roles = user_params[:roles].compact_blank
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, roles: [])
    end
  end
end
