class ZipToCbsa < ApplicationRecord
  require 'csv'
  require 'open-uri'

  def self.reload(csv_s3_path)
    # TODO: Make this safe for cases where the CSV load from s3 could fail.
    # Currently any failures from the s3 CSV load will result in an empty ZipToCbsa table. Not good.
    ZipToCbsa.delete_all
    batch, batch_size = [], 1000
    CSV.new(open(csv_s3_path, 'r:iso-8859-1'), headers: [:ZIP, :CBSA, :RES_RATIO, :BUS_RATIO, :OTH_RATIO, :TOT_RATIO]).each do |row|
      if row[:ZIP].to_s.empty?
        next
      end
      batch << ZipToCbsa.create(:zip => row[:ZIP], :cbsa => row[:CBSA], :res_ratio => row[:RES_RATIO], :bus_ratio => row[:BUS_RATIO], :oth_ratio => row[:OTH_RATIO], :tot_ratio => row[:TOT_RATIO])

      if batch.size >= batch_size
        ZipToCbsa.import batch
        batch = []
      end
    end
    ZipToCbsa.import batch
  end
end
