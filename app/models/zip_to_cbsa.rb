class ZipToCbsa < ApplicationRecord
  require 'csv'
  require 'open-uri'

  @@full_headers = [:ZIP, :CBSA, :RES_RATIO, :BUS_RATIO, :OTH_RATIO, :TOT_RATIO]
  @@name = :zip_to_cbsa

  def self.reload(csv_s3_path)
    # TODO: Make this safe for cases where the CSV load from s3 could fail.
    # Currently any failures from the s3 CSV load will result in an empty ZipToCbsa table. Not good.

    ReloadTask.update_status(@@name, 0, 0, 'UPDATING')

    Thread.new do
      ZipToCbsa.delete_all

      total_records = 0
      csv_io = open(csv_s3_path, 'r:iso-8859-1')
      csv_io.each_line {|line| total_records += 1}
      processed_records = 0
      ReloadTask.update_status(@@name, total_records, processed_records)

      csv_io.rewind
      batch, batch_size = [], 1000
      CSV.new(csv_io, headers: @@full_headers).each do |row|
        if row[:ZIP].to_s.empty?
          next
        end
        batch << ZipToCbsa.new(:zip => row[:ZIP], :cbsa => row[:CBSA], :res_ratio => row[:RES_RATIO], :bus_ratio => row[:BUS_RATIO], :oth_ratio => row[:OTH_RATIO], :tot_ratio => row[:TOT_RATIO])

        current_batch_size = batch.length
        if current_batch_size >= batch_size
          ZipToCbsa.import batch
          processed_records += current_batch_size
          ReloadTask.update_status(@@name, total_records, processed_records)
          batch = []
        end
      end
      ZipToCbsa.import batch, timestamps: false
      processed_records += batch.length
      ReloadTask.update_status(@@name, processed_records, processed_records, 'COMPLETE')
    end
  end
end
