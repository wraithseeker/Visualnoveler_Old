class RemoveSummaryFromVns < ActiveRecord::Migration
  def change
    remove_column :Vns, :summary
  end
end