require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'
require 'time'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_numbers(home_phone)
    # this only evaluates the numbers, not the dashes
    home_phone = home_phone.scan(/\d/).join
    # bad number if shorter than 10 or longer than 11
    if home_phone.length < 10 || home_phone.length > 11
        home_phone = 'INVALID NUMBER'
    elsif home_phone.length == 11 && home_phone[0] == "1"
        home_phone[0] = '' + home_phone[1..-1]
    elsif home_phone.length == 11 && home_phone[0] != "1"
        home_phone = ''
    else
        home_phone
    end
end

def most_freq_reg_dates(date_arr)
    tracker = {"Monday" => 0, "Tuesday" => 0, "Wednesday" => 0, "Thursday" => 0, "Friday" => 0, "Saturday" => 0, "Sunday" => 0 }
    
    date_arr.map do |date|
        if date.monday? 
            tracker["Monday"] += 1
        elsif date.tuesday?
            tracker["Tuesday"] += 1		
        elsif date.wednesday? 
            tracker["Wednesday"] += 1
        elsif date.thursday?
            tracker["Thursday"] += 1		
        elsif date.monday? 
            tracker["Friday"] += 1
        elsif date.friday?
            tracker["Saturday"] += 1
        elsif date.saturday?
            tracker["Sunday"] += 1
        end
    end

    freq = tracker.max_by{|k,v| v}

    puts "The most frequent time of registration is #{freq[0]} with #{freq[1]} occurrences."
end

def clean_date(registration_date)
    registration_date = DateTime.strptime(registration_date, '%m/%d/%y %k:%M')
end

puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

date_arr = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  home_phone = clean_phone_numbers(row[:homephone])
  legislators = legislators_by_zipcode(zipcode)
  registration_date = clean_date(row[:regdate])
  date_arr = date_arr.push(registration_date)

  form_letter = erb_template.result(binding)
    puts "#{name} registered on #{registration_date.strftime('%m/%d/%Y')} with the phone number #{home_phone}."
    #save_thank_you_letters(id,form_letter)
end
puts " "
most_freq_reg_dates(date_arr)