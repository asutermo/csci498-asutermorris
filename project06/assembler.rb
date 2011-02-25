#I rewrote this after seeing the example given in class
#my original code worked well, except for NIL args, so
#here's the rewritten code.

#initiate main info
#test to make sure input arguments are valid
def args_valid?
	ARGV[0] && File.extname(ARGV[0]) == '.asm' && ARGV.size == 1
end
unless args_valid?
	p "Invalid argument"
	Process.exit #if args are invalid we quit
end


#this class is the parser. It will read an assembly command
#parse it and provide access to command's components.
#also removes white space and comments
class Parser
	#open input file/stream, get ready to parse it
	def initalize(filei)
		@filei = filei
		File.open(@filei, 'r')
	end

	#checks more more commands in input
	def hasMoreCommands
	#if blah 
		#return true;
	#else
		#return false;
	end

	#reads next command from input, makes it current command
	#only called if hasMoreCommands() is true
	def advance
	end

	#return type of current command. A_Command for @Xxx
	#C_Command for dest=comp;jump. L-Command for Xxx
	def commandType
	end

	#returns symbol or decimal Xxx of current command
	def symbol
	end

	#return dest mnemonic in C-command
	def dest
	end

	#return jump mnemonic in C-command
	def comp
	end

	def jump
	end
end


#do what's essential a try-catch clause
begin
	p "Moving along"
	a_file=ARGV[0]	#get the file name from arguments
	a_base = File.basename(a_file, '.asm')	#get the base (extensionless) file name
	a_path = File.split(a_file)[0]	#get file path
	h_file = "#{a_path}/#{a_base}.hack"	#generate a hack file
	parse = Parser.new(ARGV[0])
	p "Still here"
rescue Exception => e	#if there's any issue with opening files, generate exception
	puts "ERROR! You suck!" + e
end


#this class translates Hack mnemonics into binary
class Code
	#return binary code of dest
	def dest(mnemonic)
	end
	#return binary code of comp
	def comp(mnemonic)
	end
	#return binary code of jump
	def jump(mnemonic)
	end

end

#This turns symbols into actual addresses
class SymbolTable
	#create new empty symbol table
	def constructor
	end
	#add pair symbol, address to table
	def addEntry(symbol, address)
	end
	#does symbol table contain the symbol
	def contains(symbol)
	end
	#return address associated with symbol
	def getAddress(symbol)
	end
end