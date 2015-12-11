class RemoveDescriptionColumnFromLinks < ActiveRecord::Migration
  def change
    remove_column :links, :description
  end
end
