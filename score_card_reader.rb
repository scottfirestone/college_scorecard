require 'csv'
require 'pry'

class ScorecardReader

  def load_data
    @csv_data = CSV.open('2013_college_scorecards.csv', headers: true, header_converters :symbol)
  end

  def get_income_data
    load_data
    data = {}
    testing = @csv_data.readlines.each do |line|
      binding.pry
      School.new({"name" => line[:INSTNN],
                  "state" => line[:STABBR],
                  "faculty_salary" => line[:AVGFACSAL],
                  "grad_debt" => line[:GRAD_DEBT_MDN]})
    end
  end

end
