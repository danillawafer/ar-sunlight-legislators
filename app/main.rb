require 'sqlite3'
require 'active_record'
require_relative 'models/senator'


ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "../db/ar-sunlight-legislators.sqlite3")
connection_handle = ActiveRecord::Base.connection

def congress_members_by_state(state)
  representatives = []
  senators = []
  congress_members = CongressMember.where("state = ?",state).select("firstname,lastname,party,title")
  congress_members.order("lastname")
  congress_members.each do |member|
    if member.title == 'Rep'
      representatives << member
    else
      senators << member
    end
  end
  puts "Senators:"
  senators.each do |member|
    puts "  #{member.firstname} #{member.lastname} (#{member.party})"
  end
  puts "Representatives:"
  representatives.each do |member|
    puts "  #{member.firstname} #{member.lastname} (#{member.party})"
  end
end

#congress_members_by_state('HI')

def percent_by_gender(gender)
  total_gender_rep = CongressMember.where(title: 'Rep',in_office: '1',gender: gender).count
  total_gender_sen = CongressMember.where(title: 'Sen',in_office: '1',gender: gender).count

  total_rep = CongressMember.where(title: 'Rep', in_office: '1').count
  total_sen = CongressMember.where(title: 'Sen', in_office: '1').count

  gender_rep_average = (total_gender_rep.to_f / total_rep.to_f) * 100
  gender_sen_average = (total_gender_sen.to_f / total_sen.to_f) * 100

  if gender == 'M'
    gender = 'Male'
  else
    gender = 'Female'
  end

  p total_gender_sen
  p total_gender_rep
  p total_rep
  p total_sen
  p gender_sen_average.class
  p gender_rep_average.class

  puts "#{gender} Senators: #{total_gender_sen} (%#{gender_sen_average.to_i})"
  puts "#{gender} Representatives: #{total_gender_rep} (%#{gender_rep_average.to_i})"
end

#percent_by_gender('M')

def list_of_congressmembers
  find_senators = CongressMember.where(in_office: '1', title: 'Sen').select("state").group("state").count
  find_representatives = CongressMember.where(in_office: '1', title: 'Rep').select("state").group("state").count
  sorted_reps = find_representatives.sort{|state, rep| state[1] <=> rep[1]}.reverse
  reps = Hash[sorted_reps]

  reps.each_pair do |state,reps|
    puts "#{state} #{find_senators[state]} Senators, #{reps} Representatives"
  end
end  

# list_of_congressmembers

def all_congressmembers
  representatives = CongressMember.where(title: 'Rep').count
  senators = CongressMember.where(title: 'Sen').count

  puts "Representatives: #{representatives}"
  puts "Senators: #{senators}"
end

all_congressmembers

CongressMember.destroy_all(:in_office => '0')

all_congressmembers
