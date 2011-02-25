#test to make sure input arguments are valid before anything else
def args_valid?
	ARGV[0] && File.extname(ARGV[0]) == '.asm' && ARGV.size == 1 && File.exist?(ARGV[0])
end
unless args_valid?
	p "Invalid argument. File either does not have .asm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end

#the following are all of the class definitions. We have Parser, Code, and SymbolTable

#this class is the parser. It will read an assembly command
#parse it and provide access to command's components.
#also removes white space and comments
class Parser
	#open input file/stream, get ready to parse it
	def initalize(arg)
		@A_COMMAND = A_COMMAND			#for A-Commands
		@L_COMMAND = L_COMMAND			#for L-Commands
		@C_COMMAND = C_COMMAND			#for C-Commands
		@CMD = ''						#this is our current command
		@in = File.open(ARGV[0], 'r')	#open the input stream
	end

	#checks more more commands in input
	def hasMoreCommands
		i = 0
	#if blah 
		#return true;
	#else
		#return false;
	end

	#reads next command from input, makes it current command
	#only called if hasMoreCommands() is true
	def advance
		if (hasMoreCommands)
			@cmd = @in.readline
		end
	end

	#return type of current command. A_Command for @Xxx
	#C_Command for dest=comp;jump. L-Command for Xxx
	def commandType
		if (cmd[0,1].eql?('@')) 
			return A_COMMAND
		elsif (cmd[0,1].eql?('('))
			return L_COMMAND
		else
			return C_COMMAND
		end
	end

	#returns symbol or decimal Xxx of current command
	def symbol
		if (cmd[0,1].eql('@'))
			return cmd.gsub('@', '')
		elsif (cmd[0,1].eql('('))
			return cmd.delete "(",")"
		end
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

#this class translates Hack mnemonics into binary
class Code
	def initialize(arg)
		@oFile = File.open(arg, 'w')
	end
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
	def initialize
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

#do what's essentially a try-catch clause to open file
begin
	p "Moving along"
	a_file=ARGV[0]								#get the file name from arguments
	a_base = File.basename(a_file, '.asm')		#get the base (extensionless) file name
	a_path = File.split(a_file)[0]				#get file path
	p File.path(a_file)
	h_file = "#{a_path}/#{a_base}.mine.hack"	#generate a hack file
	p File.path(h_file)
	parse = Parser.new(ARGV[0]) 				#send input file for parsing
	code = Code.new(ARGV[0])					#send output file for output
	p "Still here"	
rescue Exception => e	#if there's any issue with opening files, generate exception
	puts "ERROR! You suck!" + e
end