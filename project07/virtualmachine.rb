#!/usr/bin/env ruby

#make sure file is good
def args_valid?
	ARGV.size == 1 && File.exist?(ARGV[0]) || Dir.exist?(Dir.pwd + "/" + ARGV[0])
end
unless args_valid?
	p "Invalid argument. File or Path either does not have .vm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end

class CodeWriter
	#open output file stream, get ready to write to it
	def initialize(filepath)
		
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


#start parsing
class Parser
	#open file stream, and get ready to parse it
	def initialize()
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

class Translate
	def initialize(path)
		puts "Initalize"
		path = Dir.pwd + "/" + path
		puts path
		@files = parse_filenames(path)
		@output = ''
	
		#code = CodeWriter.new(output)
		# for file in @files do
			# process_filenames(file)
		# end
		#code.close()
		
	end
	
	def parse_filenames(path)
		puts "parsing " + path
		if Dir.exist?(path)
			puts path
			dirname = path.chomp
			puts "Directory exists! " + dirname
			@files = Dir.glob("*.vm")
			puts @files.length
			if (@files.length == 0)
				raise  StandardError, "no files to open"
			end 
			Dir.chdir(path)
			name = File.basename(Dir.getwd)
			@output = File.open(name + ".asm", 'w')
		elsif File.file?(path)
			puts path
			@files = path
			f_path = File.split(path)[0]
			f_base = File.basename(path, '.vm')
			nFile = "#{f_path}/#{f_base}.asm"
			@output = File.open(nFile, 'w')
		else
			raise "ERROR, not a file or directory!"
		end
		return @files
	end
	
	def process_filenames(path)
		#parse = Parser.new(path)
	end
end


# get file name, attempt run
path = ARGV[0]
begin
	trans = Translate.new(path)
rescue Exception => e
	puts "Error you suck!"
	puts e
end