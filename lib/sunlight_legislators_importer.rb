require 'csv'
require_relative '../app/models/senator'

class SunlightLegislatorsImporter
  def self.import(filename)
    csv = CSV.new(File.open(filename))
    csv.each do |row|
      if row[0] == 'title'
        @keys = row
      else
        congress_member_attributes = Hash[@keys.zip(row)]
        CongressMember.create!(congress_member_attributes)
      end
    end
  end
end



# IF YOU WANT TO HAVE THIS FILE RUN ON ITS OWN AND NOT BE IN THE RAKEFILE, UNCOMMENT THE BELOW
# AND RUN THIS FILE FROM THE COMMAND LINE WITH THE PROPER ARGUMENT.
# begin
#   raise ArgumentError, "you must supply a filename argument" unless ARGV.length == 1
#   SunlightLegislatorsImporter.import(ARGV[0])
# rescue ArgumentError => e
#   $stderr.puts "Usage: ruby sunlight_legislators_importer.rb <filename>"
# rescue NotImplementedError => e
#   $stderr.puts "You shouldn't be running this until you've modified it with your implementation!"
# end
