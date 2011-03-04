#!/usr/bin/env ruby

#make sure file is good
def args_valid?
	ARGV.size == 1 && File.exist?(ARGV[0]) || Dir.exist?(Dir.pwd + "/" + ARGV[0])
end
unless args_valid?
	p "Invalid argument. File or Path either does not have .vm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end

#globals...so shoot me
$C_ARITHMETIC = 0
$C_PUSH = 1
$C_POP = 2
$C_LABEL = 3
$C_GOTO = 4
$C_IF = 5
$C_FUNCTION = 6
$C_RETURN = 7
$C_CALL = 8 

$ARITHMETIC_COMMANDS = ["add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"]
	

class CodeWriter
	#open output file stream, get ready to write to it
	def initialize(filepath)
		#all file checking has been done in Translate, open it
		@file = File.open(filepath, 'w')
		@counter = 0
		@currentName = ""
	end
	
	#inform code writer that translation of a new VM file is started
	def setFileName(filename)
		@currentName = filename
	end
	
	#wirte assembly code that is the translation of given arithmetic command
	def writeArithmetic(command)

	end
	
	#write assemvly code that is translation of given comand, where it is
	#either push or pop
	def writePushPop(command, segment, index)
		
	end

	 def push()
	end

    #Pops the stack and puts the value into the D register
    def pop()
    end

    def pushFromRAM(index)
	end

    def preambleLocationInMemory(segmentVar)
	end

    def preambleLocationIsMemory(memoryLoc)
	end

    def storeToRAM(index)
    end

    def greaterThanLessThanJump(jumpCmd)
	end

	#close output file
	def close
		@file.close()
	end
end

#start parsing
class Parser
	#open file stream, and get ready to parse it
	def initialize(filename)
		#all file checking has been done in Translate, open it
		@file = File.open(filename, 'r')
		@commands = []
		@counter = 0
		while (@lines = @file.gets)
			@current = @lines
			@stripped = @lines.strip
			if (@lines.empty?)
				next
			end
			if !(/\/\//.match(@stripped) or @stripped.length == 0)
				@commands << @stripped
			else
				next
			end
		end
		@counter = -1
		puts @commands
	end

	def current()
        return @commands[@counter]
	end

    def hasMoreCommands()
       return @counter + 1 < @commands.length
	end

    def advance()
        @counter += 1
        return @commands[@counter]
    end

    def commandType()
        for command in $ARITHMETIC_COMMANDS
            if command == current()
                return $C_ARITHMETIC
			end
		end
        if /push/.match(current())
            return $C_PUSH
        elsif /pop/.match(current())
            return $C_POP
		end
	end


    def arg1()
        if commandType() == $C_RETURN
            raise TypeError("Trying to get the first argument on a return command")
		end
        if commandType() == $C_ARITHMETIC
            result=/\w+/.match(current())
            return result.string
        else
			result = current.gsub(/^\w+\s/, '')
			result = result.gsub(/\d/, '')
			result.strip
			result.chomp
			puts "res1: " + result
            return result
		end
    end  
       
    def arg2
        type = commandType()
		puts type
        if type != $C_PUSH and type != $C_POP and type != $C_FUNCTION and type != $C_CALL
           raise TypeError("Cannot get the second argument for this command")
		end
		result = current.gsub(/\D+/, '')
		puts "res2: " + result
		result.chomp
        return result
	end

	def close
		@file.close()
	end
end

class Translate
	def initialize(path)
		#modify path, make instance vars
		path = Dir.pwd + "/" + path
		@output = ''
		
		#parse the file
		@files = parse_filenames(path)
		
		#generate a code writer
		@code = CodeWriter.new(@output)
		
		#begin the processing
		@files.each { |file| process_filenames(file) }
		
		#close the code writer
		@code.close()
	end
	
	#this actually does the file/dir checking
	def parse_filenames(path)
		#first if checks if it's a directory, a file or neither
		if Dir.exist?(path)
			dirname = path.chomp
			
			#change our directory to the path, grab only .vm files
			Dir.chdir(path)
			@files = Dir.glob("*.vm")
			
			#if we have no files, there's nothing we can do, EXCEPTION
			if (@files.length == 0)
				raise  StandardError, "No files to open"
			end 
			
			#generate our output path
			Dir.chdir(path)
			name = File.basename(Dir.getwd)
			@output = name + ".asm"
		elsif File.file?(path)
			#make sure the file is of the .vm type
			if (File.extname(path) == '.vm')
				#generate our output path
				@files = path
				f_path = File.split(path)[0]
				f_base = File.basename(path, '.vm')
				nFile = "#{f_path}/#{f_base}.asm"
				@output = nFile
			else
				raise "Error, cannot open this file!"
			end
		else
			raise "ERROR, not a file or directory!"
		end
		
		#return everything
		return @files
	end
		
	def process_filenames(path)
		puts "generating parser, setting code file name"
		parser = Parser.new(path)
		@code.setFileName(path)
		while parser.hasMoreCommands
			parser.advance
			if parser.commandType == $C_ARITHMETIC
				@code.writeArithmetic(parser.arg1())
			elsif parser.commandType == $C_PUSH || parser.commandType == $C_POP
				@code.writePushPop(parser.commandType, parser.arg1(), parser.arg2())
			else 
				raise "Command error"
			end
		end
		
		parser.close()
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