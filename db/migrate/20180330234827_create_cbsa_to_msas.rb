class CreateCbsaToMsas < ActiveRecord::Migration[5.1]
  def up
    create_table :cbsa_to_msas, :id => false do |t|
      t.column "cbsa", :integer, :null => false, :index => true
      t.column "mdiv", :integer, :null => true, :index => true
      t.column "name", :string, :limit => 80, :null => false
      t.column "lsad", :string, :limit => 40, :null => false, :index => true
      t.column "popestimate2014", :integer, :null => false
      t.column "popestimate2015", :integer, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :cbsa_to_msas
  end

end
