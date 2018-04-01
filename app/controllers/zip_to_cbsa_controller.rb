class ZipToCbsaController < ApplicationController
  def reload
    ZipToCbsa.reload(APP_CONFIG[:csv_zip_to_cbsa])
    redirect_to root_path, notice: "ZIP to CBSA data refreshed from s3"
  end
end
