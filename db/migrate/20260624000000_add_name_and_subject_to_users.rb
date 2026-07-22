class AddNameAndSubjectToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :subject, :string unless column_exists?(:users, :subject)
  end
end
