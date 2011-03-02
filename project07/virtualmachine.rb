#!/usr/bin/env ruby

#make sure file is good
def args_valid?
	(File.extname(ARGV[0]) == '.vm' && ARGV.size == 1 && File.exist?(ARGV[0]) || File.directory?(ARGV[0]))
end
unless args_valid?
	p "Invalid argument. File either does not have .asm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end

def parse_filenames(path)
	if File.directory?(path)
	end
	#dirname=path.chom
end

#start parsing
class Parser
	#open file stream, and get ready to parse it
	def initialize(file)
		#line counter
		lineCount = 0

		#open our file, get path and base name. this should be a .vm file
		f = File.open(file, 'r')
		f_path = File.split(f)[0]
		f_base = File.basename(f, '.vm')

		#open file to write to, this is a .asm file
		nFile = "#{f_path}/#{f_base}.asm"
		newFile = File.open(nFile, "w")
	end
	
	#are there more commands in the input
	def hasMoreCommands
	end
	
	#reads next command from input, makes it current command, only called
	#if hasMoreCommands is true. initially there is no current commands
	def advance
	end
	
	#returns type of the current vm command. C_arithmetic is returned
	#for all arithemetic commands
	def commandType
	end
	
	#returns first argument of current command. shouldnt be called if current command
	#is c_return
	def arg1
	end
	
	#returns second argument of current command. only calld if current command
	#is push, pop, function or call
	def arg2
	end
end

class CodeWriter
	#open output file stream, get ready to write to it
	def initialize(outputfile)
	end
	
	#inform code writer that translation of a new VM file is started
	def setFileName(filename)
	end
	
	#wirte assembly code that is the translation of given arithmetic command
	def writeArithmetic(command)
	end
	
	#write assemvly code that is translation of given comand, where it is
	#either push or pop
	def writePushPop(command, segment, index)
	end
	
	#close output file
	def close
	end
end

# get file name, attempt run
file = ARGV[0]
begin
	parse = Parser.new(file)
	cw = CodeWriter.new(file)
rescue Exception => e
	puts "Error you suck!"
	puts e
end