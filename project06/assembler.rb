
#i rewrote this after seeing the example given in class
#my original code worked well, except for NIL args, so
#here's the rewritten code.

#test to make sure input arguments are valid
def args_valid?
	ARGV[0] && File.extname(ARGV[0]) == '.asm' && ARGV.size == 1
end
unless args_valid?
	Process.exit #if args are invalid we quit
end

#do what's essential a try-catch clause
begin
	a_file=ARGV[0]	#get the file name from arguments
	a_base = File.basename(a_file, '.asm')	#get the base (extensionless) file name
	a_path = File.split(a_file)[0]	#get file path
	h_file = "#{a_path}/#{a_base}.hack"	#generate a hack file
	File.open(a_file, 'r') do |infile|	#open our assembly file
		outFile = File.open(h_file, 'w') do |outfile|	#open our hack file
			#insert code
		end
	end
rescue Exception => e	#if there's any issue with opening files, generate exception
	puts "ERROR! You suck!" + e
end
