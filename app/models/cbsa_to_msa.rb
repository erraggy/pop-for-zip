class CbsaToMsa < ApplicationRecord
  require 'csv'
  require 'open-uri'

  @@name = 'cbsa_to_msa'
  @@full_headers = [:CBSA, :MDIV, :STCOU, :NAME, :LSAD, :CENSUS2010POP, :ESTIMATESBASE2010, :POPESTIMATE2010, :POPESTIMATE2011, :POPESTIMATE2012, :POPESTIMATE2013, :POPESTIMATE2014, :POPESTIMATE2015, :NPOPCHG2010, :NPOPCHG2011, :NPOPCHG2012, :NPOPCHG2013, :NPOPCHG2014, :NPOPCHG2015, :BIRTHS2010, :BIRTHS2011, :BIRTHS2012, :BIRTHS2013, :BIRTHS2014, :BIRTHS2015, :DEATHS2010, :DEATHS2011, :DEATHS2012, :DEATHS2013, :DEATHS2014, :DEATHS2015, :NATURALINC2010, :NATURALINC2011, :NATURALINC2012, :NATURALINC2013, :NATURALINC2014, :NATURALINC2015, :INTERNATIONALMIG2010, :INTERNATIONALMIG2011, :INTERNATIONALMIG2012, :INTERNATIONALMIG2013, :INTERNATIONALMIG2014, :INTERNATIONALMIG2015, :DOMESTICMIG2010, :DOMESTICMIG2011, :DOMESTICMIG2012, :DOMESTICMIG2013, :DOMESTICMIG2014, :DOMESTICMIG2015, :NETMIG2010, :NETMIG2011, :NETMIG2012, :NETMIG2013, :NETMIG2014, :NETMIG2015, :RESIDUAL2010, :RESIDUAL2011, :RESIDUAL2012, :RESIDUAL2013, :RESIDUAL2014, :RESIDUAL2015]

  def self.reload(csv_s3_path)
    # TODO: Make this safe for cases where the CSV load from s3 could fail.
    # Currently any failures from the s3 CSV load will result in an empty CbsaToMsa table. Not good.

    ReloadTask.update_status(@@name, 0, 0, 'UPDATING')

    Thread.new do
      CbsaToMsa.delete_all

      total_records = 0
      csv_io = open(csv_s3_path, 'r:iso-8859-1')
      csv_io.each_line {|line| total_records += 1}
      processed_records = 0
      ReloadTask.update_status(@@name, total_records, processed_records)

      csv_io.rewind
      batch, batch_size = [], 100
      CSV.new(csv_io, headers: @@full_headers).each do |row|
        if row[:CBSA].to_s.empty?
          next
        end
        batch << CbsaToMsa.new(:cbsa => row[:CBSA], :mdiv => row[:MDIV], :name => row[:NAME], :lsad => row[:LSAD], :popestimate2014 => row[:POPESTIMATE2014], :popestimate2015 => row[:POPESTIMATE2015])

        current_batch_size = batch.length
        if current_batch_size >= batch_size
          CbsaToMsa.import batch
          processed_records += current_batch_size
          ReloadTask.update_status(@@name, total_records, processed_records)
          batch = []
        end
      end
      CbsaToMsa.import batch
      processed_records += batch.length
      ReloadTask.update_status(@@name, processed_records, processed_records, 'COMPLETE')
    end

  end
end
