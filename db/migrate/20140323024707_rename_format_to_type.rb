class RenameFormatToType < ActiveRecord::Migration
  def change
    rename_column :questions, :format, :type
  end
end
