
#make sure file is good
def args_valid?
	ARGV[0] && File.extname(ARGV[0]) == '.asm' && ARGV.size == 1 && File.exist?(ARGV[0])
end
unless args_valid?
	p "Invalid argument. File either does not have .asm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end

#initial tables and other values
hashTable = {}
ramstart = 16
comp = {'0'=> '0101010', '1'=> '0111111', '-1'=> '0111010', 'D'=> '0001100',
'A'=> '0110000', '!D'=> '0001101', '!A'=> '0110001', '-D'=> '0001111',
'-A'=> '0110011', 'D+1'=> '0011111', 'A+1'=> '0110111', 'D-1'=> '0001110',
'A-1'=> '0110010', 'D+A'=> '0000010', 'D-A'=> '0010011', 'A-D'=> '0000111',
'D&A'=> '0000000', 'D|A'=> '0010101', 'M'=> '1110000', '!M'=> '1110001', 
'-M'=> '1110011', 'M+1'=> '1110111',
'M-1'=> '1110010', 'D+M'=> '1000010', 'D-M'=> '1010011', 'M-D'=> '1000111',
'D&M'=> '1000000', 'D|M'=> '1010101'}
jmp = {'JGT'=> '001', 'JEQ'=> '010', 'JGE'=> '011', 'JLT'=> '100', 
'JNE'=> '101', 'JLE'=> '110', 'JMP'=> '111'}
dest = {'M'=> '001', 'D'=> '010', 'MD'=> '011', 'A'=> '100', 
'AM'=> '101', 'AD'=> '110', 'AMD'=> '111'}
#predefined symbol table
symbols={
	"SP"=>0,
	"LCL"=>1,
	"ARG"=>2,
	"THIS"=>3,
	"THAT"=>4,
	"R0"=>0,
	"R1"=>1,
	"R2"=>2,
	"R3"=>3,
	"R4"=>4,
	"R5"=>5,
	"R6"=>6,
	"R7"=>7,
	"R8"=>8,
	"R9"=>9,
	"R10"=>10,
	"R11"=>11,
	"R12"=>12,
	"R13"=>13,
	"R14"=>14,
	"R15"=>15,
	"SCREEN"=>16384,
	"KBD"=>24576
}
#start parsing
def Parser(filename)
	#line counter
	lineCount = 0

	#open our file, get path and base name
	f = File.open(filename, 'r')
	f_path = File.split(f)[0]
	f_base = File.basename(f, '.asm')
	
	#scan for symbols into hash table
	for line in f
		#skip comments, new lines
		if (line[0..2] == "//" or line == '\n')
			next
		end
		#parse a line
		line = parseLine(line)
		if line.length == 0
			next
		end
		#get command type
		commandType = cType(line)	
		#determine if command is necessary
		if commandType == 'L_COMMAND'
			hashTable[line[1..-1]] = lineCount
		else
			lineCount += 1
		end
	end	
	#move file to beginning
	f.pos = 0
	
	#open file to write to, this is a .hack file
	nFile = "#{f_path}/#{f_base}.hack"
	newFile = File.open(nFile, "w")
	
	#while we get lines, skip any comments, new lines
	while (line = f.gets)
		if (line[0..2] == "//" or line == '\n')
			next
		end
		#parse the line
		line = parseLine(line)
		#check if it blank
		if line.length == 0
			next
		end
		#get the commnd type 
		commandType = cType(line)
		#unknown? quit
		if (commandType == 'Error')
			print "Assembler Error on line : " + line
		end		
		#print code
		if commandType == 'A_COMMAND'
			machineCode = aCommand(line)
		elsif commandType == 'C_COMMAND'
			machineCode = cCommand(line)
		end
		#write code
		if commandType == 'A_COMMAND' || commandType == 'C_COMMAND'
			# write this line
			newFile.write(machineCode + "\n")
		end
	end
	# close the file
	f.close()
	newFile.close()
end
# returns the c-instruction
def cCommand(input)
	return '111' + comp(input) + dest(input) + jump(input)
end
#comp
def comp(input)
	if input.scan('=') == true
		input = input[input.index('=')+1..input.last]
	elsif input.scan(';') == true
		input = input[0..input.index(';')]
	else
		return '0000000'
	end
		
	return comp[input]
end

#dest
def dest(input)
	if input.scan('=') == true
		destSgmt = input[0..input.index('=')]
		return dest[destSgmt]
	else
		return '000'
	end
	return '000'
end
	
#jump
def jump(input)
	if input.index(';') == nil
		return '000'
	else
		jmpSgmt = input[input.index(';')+1..input.last]
		return jmp[jmpSgmt]
	end
end

# returns a-instr		
def aCommand(input)
	input = input[1..(input.size-1)]
	if input[0,1].match(/\d/)
		input = input
	elsif hashTable.key?(input)
		input = hashTable[input]
	else
		#store variable
		hashTable[input] = ramstart
		input = ramstart
		ramstart += 1
	end
	num = ((Integer(input)).to_s(2))
	num = num + "0" * (16-num.length-1)
	puts num
	return '0' + num.to_str
end

#get command type
def cType(c)
	#predefine command types
	command = ['A_COMMAND', 'C_COMMAND', 'L_COMMAND', 'ERROR']
	if c[0] == '@'
		return command[0]	#A-instruction
	elsif c[0] == '(' and c[c.length-1] == ')'
		return command[2]	#Label
	elsif c.scan(';') or c.scan('=')
		return command[1]	#C-instruction
	else
		return command[3] 	#Unknown
	end	
end

#line parser
def parseLine(input)
	#bye bye white space
	input = input.chomp(" ")
	#and new lines
	input = input.chomp('\n')	
	#remove comments
	if input.scan('//') == true
		input = input[0..input.index('//')]
	end
	return input
end

# get file name, attempt run
file = ARGV[0]
begin
	Parser(file)
rescue Exception => e
	puts "Error you suck!"
end