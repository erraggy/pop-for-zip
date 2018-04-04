class LookupController < ApplicationController

  def show
    for_zip = params[:zip].to_s.strip

    @result = { :Zip => for_zip, :CBSA => :NOT_FOUND, :MSA => :NOT_FOUND, :Pop2014 => :NOT_FOUND, :Pop2015 => :NOT_FOUND }

    cbsa_row = ZipToCbsa.where("zip = ?", for_zip).first
    if cbsa_row == nil or cbsa_row[:cbsa] == 99999
      # Not found... let user know...
      flash[:notice] = "No CBSA found for zip."
    else
      alt_cbsa_row = CbsaToMsa.where("mdiv = ?", cbsa_row[:cbsa]).first
      cbsa = alt_cbsa_row == nil ? cbsa_row[:cbsa] : alt_cbsa_row[:cbsa]

      lookup_row = CbsaToMsa.where("cbsa = ? AND lsad = 'Metropolitan Statistical Area'", cbsa).first
      @result[:CBSA] = cbsa
      @result[:MSA] = lookup_row[:name]
      @result[:Pop2015] = lookup_row[:popestimate2015]
      @result[:Pop2014] = lookup_row[:popestimate2014]
    end

    respond_to do |format|
      format.html
      format.json { render json: @result }
    end
  end
end
