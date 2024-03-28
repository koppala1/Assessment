class RenameDateToLowerCaseInTasks < ActiveRecord::Migration[7.1]
  def change
    rename_column :tasks, :Date, :date
  end
end
