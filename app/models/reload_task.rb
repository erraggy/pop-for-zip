class ReloadTask < ApplicationRecord
  def self.update_status(name, total_records, records_processed, force_status = nil)
    task = ReloadTask.find_by(name: name)
    if force_status != nil
      task.status = force_status
    else
      task.status = records_processed == total_records ? 'COMPLETE' : 'UPDATING'
    end
    task.total_records = total_records
    task.records_processed = records_processed
    task.save
  end
end
