class AddPasswordDigestToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
    unless User.column_names.include?('password_digest')
      reversible do |dir|
        dir.up do
          change_column_null :users, :password_digest, true
            User.update_all(password_digest: '')
            change_column_null :users, :password_digest, false
        end
        dir.down do
          # On rollback, revert the null constraint (if needed)
          change_column_null :users, :password_digest, true
        end
      end
    end
  end
end
