require 'csv'

class CollegeScorecard
  def open_csv
    CSV.open('2013_college_scorecards.csv', headers: true, header_converters: :symbol)
  end

  def load_data
    @data = []
    open_csv.readlines.each do |line|
      @data << {"name" => line[:instnm],
                  "state" => line[:stabbr],
                  "faculty_salary" => line[:avgfacsal],
                  "grad_debt" => line[:grad_debt_mdn]}
    end
  end

  def by_state(state)
    results = @data.select { |school| school["state"] == state }
    results.each { |school| puts school["name"] }
  end

  def top_average_faculty_salary(amount)
    schools_by_faculty_salary.reverse.take(amount).each { |school| puts school["name"] }
  end

  def median_debt_between(floor, ceiling)
    schools_in_range = schools_by_debt_in_range(floor, ceiling)
    sorted_schools_in_range = schools_in_range.sort_by { |school| school["grad_debt"].to_i }.reverse
    sorted_schools_in_range.each { |school| puts "#{school["name"]} ($#{school["grad_debt"]})" }
  end

  def command_line_interface
    case ARGV[0]
    when 'by_state'
      by_state(ARGV[1])
    when 'top_average_faculty_salary'
      top_average_faculty_salary(ARGV[1].to_i)
    when 'median_debt_between'
      median_debt_between(ARGV[1].to_i, ARGV[2].to_i)
    end
  end

  private

  def schools_by_faculty_salary
    @data.sort_by { |school| school["faculty_salary"].to_i }
  end

  def schools_by_debt_in_range(floor, ceiling)
    @data.select { |school| school["grad_debt"].to_i < ceiling && school["grad_debt"].to_i > floor }
  end
end

cs = CollegeScorecard.new
cs.load_data
cs.command_line_interface
