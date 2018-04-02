class HomeController < ApplicationController
  def index
    @result = {}
    ReloadTask.all.each do |row|
      @result[row[:name]] = { :status => row[:status], :total_records => row[:total_records], :records_processed => row[:records_processed] }
    end

  end
end
