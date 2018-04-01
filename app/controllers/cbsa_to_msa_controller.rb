class CbsaToMsaController < ApplicationController
  def reload
    CbsaToMsa.reload(APP_CONFIG[:csv_cbsa_to_msa])
    redirect_to root_path, notice: "CBSA to MSA data refreshed from s3"
  end
end
