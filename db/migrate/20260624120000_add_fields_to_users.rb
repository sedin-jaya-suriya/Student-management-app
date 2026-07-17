class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string unless column_exists?(:users, :name)
    add_column :users, :role, :string, default: 'teacher' unless column_exists?(:users, :role)
    add_column :users, :subject, :string unless column_exists?(:users, :subject)
  end
end
