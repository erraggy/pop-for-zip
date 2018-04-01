class CreateZipToCbsas < ActiveRecord::Migration[5.1]
  def up
    create_table :zip_to_cbsas, :id => false do |t|
      t.column "zip", :string, :limit => 5, :null => false, :index => true
      t.column "cbsa", :integer, :null => false
      t.column "res_ratio", :decimal, :precision => 10, :scale => 9, :null => false
      t.column "bus_ratio", :decimal, :precision => 10, :scale => 9, :null => false
      t.column "oth_ratio", :decimal, :precision => 10, :scale => 9, :null => false
      t.column "tot_ratio", :decimal, :precision => 10, :scale => 9, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :zip_to_cbsas
  end

end
