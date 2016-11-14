class CreateGbAdminRoles < ActiveRecord::Migration
  def change
    create_table :gb_admin_roles do |t|
      t.integer :user_id
      t.string :role
    end
  end
end
