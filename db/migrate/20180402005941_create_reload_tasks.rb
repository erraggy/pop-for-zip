class CreateReloadTasks < ActiveRecord::Migration[5.1]
  def up
    # Create the table
    create_table :reload_tasks do |t|
      t.string :name, :limit => 15, :null => false
      t.string :status, :limit => 10, :null => false, :default => "UPDATING"
      t.integer :total_records, :null => false, :default => 0
      t.integer :records_processed, :null => false, :default => 0

      t.timestamps
    end

    # Add our indexes
    add_index :reload_tasks, :name, unique: true
    add_index :reload_tasks, :status

    # Insert initial records
    ReloadTask.create(:name => 'zip_to_cbsa', :status => 'COMPLETE')
    ReloadTask.create(:name => 'cbsa_to_msa', :status => 'COMPLETE')
  end

  def down
    drop_table :reload_tasks
  end
end
