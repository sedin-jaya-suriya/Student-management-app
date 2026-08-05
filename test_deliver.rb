begin
  student = Student.first
  StudentMailer.report_card(student).deliver_later
  puts 'SUCCESS'
rescue => e
  puts "ERROR: #{e.class} - #{e.message}"
  puts e.backtrace.join("\n")
end
