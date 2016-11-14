module GbAdminRoleHelper

  def role_name(role)
    GbAdminRole::ROLE_NAMES[role.downcase.to_sym]
  end

  def has_role?(user_id, role)
    GbAdminRole.has_role?(user_id, role)
  end

end