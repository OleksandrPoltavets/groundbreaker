class Manage::Settings::Acl2::AccountRolesController < Manage::SettingsController
  def index
    @account_roles = current_account.account_roles
  end
  def new
    @account_role = current_account.account_roles.new
  end
  def create
    @account_role = current_account.account_roles.new(account_role_params)
    if @account_role.save
      flash[:notice] = 'Role created.'
      redirect_to manage_settings_acl2_account_roles_path
    else
      render :new
    end
  end
  def update
    @account_role = current_account.account_roles.find params[:id]
    @account_role.update_attributes account_role_params
    flash[:notice] = 'Role updated'
    redirect_to manage_settings_acl2_account_roles_path
  end
  def edit
    @account_role = current_account.account_roles.find params[:id]
  end
  def destroy
    @account_role = current_account.account_roles.find params[:id]
    current_account.account_roles.delete(@account_role)
    flash[:notice] = 'Role removed.'
    redirect_to manage_settings_acl2_account_roles_path
  end

  def rights
    @account_role = current_account.account_roles.find params[:id]
  end

  def update_rights
    @account_role = current_account.account_roles.find params[:id]
    params[:right_ids].each do |right_id, result|
      if result.to_s=='true'
        AccountRoleRight.find_or_create_by(right_id: right_id, account_role_id: params[:id])
      else
        AccountRoleRight.where(right_id: right_id, account_role_id: params[:id]).delete_all
      end
    end

    # Added new code
    GbAdminRole.assign_roles(params[:gb_admin_roles], current_account.owner_id) if params[:gb_admin_roles]

    flash[:notice] = 'Rights updated.'
    redirect_to manage_settings_acl2_account_roles_path
  end

  def users
    @account_role = current_account.account_roles.find params[:id]
  end
  def update_users
    @account_role = current_account.account_roles.find params[:id]
    params[:user_ids].each do |user_id, result|
      if result.to_s=='true'
        UserAccountRole.find_or_create_by(user_id: user_id, account_role_id: params[:id])
      else
        UserAccountRole.where(user_id: user_id, account_role_id: params[:id]).delete_all
      end
    end
    flash[:notice] = 'Users updated.'
    redirect_to manage_settings_acl2_account_roles_path
  end
  private
  def account_role_params
    params.require(:account_role).permit(:name, :description)
  end
end
