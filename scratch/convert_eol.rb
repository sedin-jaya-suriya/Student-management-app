changed = []
Dir.glob('bin/*').each do |f|
  next unless File.file?(f)
  next if f.end_with?('.cmd')
  text = File.read(f, binmode: true)
  if text.include?("\r")
    File.write(f, text.gsub("\r", ""), binmode: true)
    changed << f
  end
end
puts "Converted: #{changed.join(', ')}"
