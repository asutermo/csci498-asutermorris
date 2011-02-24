
#I rewrote this after seeing the example given in class
#my original code worked well, except for NIL args, so
#here's the rewritten code.

#initiate main info
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


#this class is the parser. It will read an assembly command
#parse it and provide access to command's components.
#also removes white space and comments
class Parser
	def initalize
	end
	
	def hasMoreCommands
	end
	
	def advance
	end
	
	def commandType
	end
	
	def symbol
	end
	
	def dest
	end

	def comp
	end
	
	def jump
	end
end

#this class translates Hack mnemonics into binary
class Code
	def dest
	end
	
	def comp
	end
	
	def jump
	end

end

#This turns symbols into actual addresses
class SymbolTable
	def initialize
	end
	
	def addEntry 
	end
	
	def contains
	end
	
	def getAddress
	end
end