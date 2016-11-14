class GbAdminRole < ActiveRecord::Base
  ROLES = %w(ROLE_CACHE ROLE_CONTENT)
  ADMIN_ROLE = 'ROLE_ADMIN'
  ROLE_NAMES = {role_cache: 'Cache Management', role_content: 'Managed Content'}

  belongs_to :user
  validates :role, presence: true, inclusion: { in: %w(ROLE_CACHE ROLE_CONTENT ROLE_ADMIN) }
  validates :user_id, presence: true

  def self.has_role?(user_id, role)
    gb_role = where(user_id: user_id)
    gb_role.any? && gb_role.first.role == role || gb_role.any? && gb_role.first.role == ADMIN_ROLE
  end

  def self.assign_roles(params, user_id=nil)
    p_count = params.count
    params.each do |role, result|
      if result.to_s=='true'
        p_count -= 1
        if p_count == 0
          self.where(user_id: user_id).delete_all
          self.find_or_create_by(user_id: user_id, role: ADMIN_ROLE)
        else
          self.find_or_create_by(user_id: user_id, role: role)
        end
      else
        self.where('user_id = ? AND (role = ? OR role = ?)', user_id, role, ADMIN_ROLE).delete_all
      end
    end if params
  end

end