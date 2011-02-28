#!/usr/bin/env ruby
#make sure file is good
def args_valid?
	ARGV[0] && File.extname(ARGV[0]) == '.vm' && ARGV.size == 1 && File.exist?(ARGV[0])
end
unless args_valid?
	p "Invalid argument. File either does not have .asm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end


#start parsing
class Parser(filename)
	#line counter
	lineCount = 0

	#open our file, get path and base name
	f = File.open(filename, 'r')
	f_path = File.split(f)[0]
	f_base = File.basename(f, '.vm')
	
end


# get file name, attempt run
file = ARGV[0]
begin
	Parser(file)
rescue Exception => e
	puts "Error you suck!"
	puts e
end