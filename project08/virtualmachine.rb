#!/usr/bin/env ruby
#Andrew Suter-Morris - Virtual Machine
#make sure file is good
def args_valid?
	ARGV.size == 1 && File.exist?(ARGV[0]) || Dir.exist?(Dir.pwd + "/" + ARGV[0])
end
unless args_valid?
	p "Invalid argument. File or Path either does not have .vm extension, is an invalid input or does not exist"
	Process.exit #if args are invalid we quit
end

#globals...so shoot me
$ARITHMETIC = 0
$PUSH = 1
$POP = 2
$LABEL = 3
$GOTO = 4
$IF = 5
$FUNCTION = 6
$RETURN = 7
$CALL = 8 

$ARITHMETIC_COMMANDS = ["add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"]

class CodeWriter
	#open output file stream, get ready to write to it
	def initialize(filepath)
		#all file checking has been done in Translate, open it
		@file = File.open(filepath, 'w')
		@counter = 0
		@currentFunc = ""
		@retNum = 0
	end

	#set file name 
	def setFileName(filename)
		@currentName = filename
	end

	def writeCall(funcName, argu)
		puts funcName
		@file.write("@return" + funcName + @retNum.to_s + "\n")
        @file.write("D=A\n")
        push()
        @file.write("@LCL\n")
        @file.write("D=M\n")
        push()
        @file.write("@ARG\n")
        @file.write("D=M\n")
        push()
        @file.write("@THIS\n")
        @file.write("D=M\n")
        push()
        @file.write("@THAT\n")
        @file.write("D=M\n")
        push()
        @file.write("@SP\n")
        @file.write("D=M\n")
        @file.write("@ARG\n")
        @file.write("M=D\n")
        @file.write("@" + argu.to_s + "\n")
        @file.write("D=A\n")
        @file.write("@ARG\n")
        @file.write("M=M-D\n")
        @file.write("@5\n")
        @file.write("D=A\n")
        @file.write("@ARG\n")
        @file.write("M=M-D\n")
        @file.write("@SP\n")
        @file.write("D=M\n")
        @file.write("@LCL\n")
        @file.write("M=D\n")
        @file.write("@" + funcName + "\n")
        @file.write("0;JMP\n")
        @file.write("(return" + funcName + @retNum.to_s + ")\n")
        @retNum += 1
	end

	#set initial address
	def wIn()
		@file.write("@256\n")
		@file.write("D=A\n")
		@file.write("@SP\n")
		@file.write("M=D\n")
		writeCall("Sys.init", 0)
	end


	#provide the arithmetic translation of the code
	def writeArithmetic(command)
		if command == "add"
            pop()
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=M+D\n")
        elsif command == "sub"
            pop()
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=M-D\n") 
        elsif command == "neg"
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=-M\n")
        elsif command == "and"
            pop()
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=M & D\n")
        elsif command == "or"
            pop()
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=M | D\n")
        elsif command == "not"
            pop()
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=!M")
        elsif command == "eq"
            label = "negate" + @counter.to_s
			@counter += 1
            pop()
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("D=M-D\n")
            @file.write("@" + label + "\n")
            @file.write("D;JEQ\n")
            @file.write("D=1\n")
            @file.write("(" + label + ")\n")
            @file.write("@SP\n")
            @file.write("A=M-1\n")
            @file.write("M=!D\n")
        elsif command == "lt"
            glJump("JLT")
        elsif command == "gt"
            glJump("JGT")
		end
	end

	#write push or pop assembly code
	def writePushPop(command, seg, index)
		seg.rstrip!
		puts @currentName
		if command == $PUSH
            if seg == "constant" 
                @file.write("@" + index.to_s + "\n")
                @file.write("D=A\n")
                push()
            elsif seg == "argument"
                locInMem("ARG")
                pfRAM(index)
            elsif seg == "local"
                locInMem("LCL")
                pfRAM(index)
            elsif seg == "this"
                locInMem("THIS")
                pfRAM(index)
            elsif seg == "that"
                locInMem("THAT")
                pfRAM(index)
            elsif seg == "temp"
                plMemory("5")
                pfRAM(index)
            elsif seg == "pointer"
                plMemory("3")
                pfRAM(index)
            elsif seg == "static"
                @file.write("@" + @currentName + "." + index.to_s + "\n")
                @file.write("D=M\n")
                push()
            else
                print("ERROR: seg undefined, seg given - " + seg)
			end
        elsif command == $POP
            if seg == "argument"
                locInMem("ARG")
                storeRAM(index)
            elsif seg == "local"
                locInMem("LCL")
                storeRAM(index)
            elsif seg == "this"
                locInMem("THIS")
                storeRAM(index)
            elsif seg == "that"
                locInMem("THAT")
                storeRAM(index)
            elsif seg == "temp"
                plMemory("5")
                storeRAM(index)
            elsif seg == "pointer"
                plMemory("3")
                storeRAM(index)
            elsif seg == "static"
                pop()
                @file.write("@" + @currentName + "." + index.to_s + "\n")
                @file.write("M=D\n")
            else
                print("ERROR: seg undefined, seg given - " + seg)
			end
		end
	end

	#determine label
	def lblName(lbl)
		return @curFunc + "$" + lbl
	end

	#print label
	def writeLbl(command)
		puts "Write lbl " + command
		command.rstrip!
		@file.write("("+lblName(command)+")\n")
	end

	#write goto statement
	def writeGo(command)
		puts "Go " + command
		command.rstrip!
		@file.write("@"+lblName(command)+"\n")
		@file.write("0;JMP\n")
	end

	#write goto-if statement
	def writeIf(command)
		puts "If " + command
		command.rstrip!
		pop()
		@file.write("@"+lblName(command)+"\n")
		@file.write("D;JNE\n")
	end

	def writeFunc(funcName, lcl)
		funcName.rstrip!
		@curFunc = funcName
		@retNum = 0
		@file.write("(" + funcName + ")\n")
		cnt = 0
		puts "func " + funcName
		while (cnt < (lcl.to_i))
			@file.write("@SP\n")
			@file.write("A=M\n")
			@file.write("M=0\n")
			@file.write("@SP\n")
			@file.write("M=M+1\n")
			cnt = cnt + 1
		end

	end


	def writeRet()
        @file.write("@LCL\n")
        @file.write("D=M\n")
        @file.write("@R13\n")
        @file.write("M=D\n")
        @file.write("@R14\n") 
        @file.write("M=D\n")
        @file.write("@5\n")
        @file.write("D=A\n")
        @file.write("@R14\n")
        @file.write("M=M-D\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
        @file.write("@R14\n")
        @file.write("M=D\n")
        pop()
        @file.write("@ARG\n")
        @file.write("A=M\n")
        @file.write("M=D\n")
        @file.write("@ARG\n")
        @file.write("D=M\n")
        @file.write("@SP\n")
        @file.write("M=D+1\n")
        @file.write("@R13\n")
        @file.write("M=M-1\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
        @file.write("@THAT\n")
        @file.write("M=D\n")
        @file.write("@R13\n")
        @file.write("M=M-1\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
        @file.write("@THIS\n")
        @file.write("M=D\n")
        @file.write("@R13\n")
        @file.write("M=M-1\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
        @file.write("@ARG\n")
        @file.write("M=D\n")
        @file.write("@R13\n")
        @file.write("M=M-1\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
        @file.write("@LCL\n")
        @file.write("M=D\n")
        @file.write("@R14\n")
        @file.write("A=M\n")
        @file.write("0;JMP\n")
	end

	#push the stack
	def push()
        @file.write("@SP\n")
        @file.write("A=M\n")
        @file.write("M=D\n")
        @file.write("@SP\n")
        @file.write("M=M+1\n")
	end

    #pop the stack
    def pop()
        @file.write("@SP\n")
        @file.write("M=M-1\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
    end

	#push from ram
    def pfRAM(index)
		puts "pf RAM " + index
        @file.write("@" + index + "\n")
        @file.write("A=D+A\n")
        @file.write("D=M\n")
        push()
	end

    def locInMem(segmentVar)
		puts "Seg var " + segmentVar
        @file.write("@" + segmentVar + "\n")
        @file.write("D=M\n")
	end

    def plMemory(memoryLoc)
		puts "PL mem " + memoryLoc
        @file.write("@" + memoryLoc.to_s + "\n")
        @file.write("D=A\n")
	end

	#store 
    def storeRAM(index)
		puts "Ram " + index
        @file.write("@13\n") 
        @file.write("M=D\n")
        @file.write("@" + index + "\n")
        @file.write("D=A\n")
        @file.write("@13\n")
        @file.write("M=M+D\n")
        @file.write("@SP\n")
        @file.write("M=M-1\n")
        @file.write("A=M\n")
        @file.write("D=M\n")
        @file.write("@13\n")
        @file.write("A=M\n")
        @file.write("M=D\n")
    end

    def glJump(jumpCmd)
		puts jumpCmd
        neg = "negate" + @counter.to_s
        setTru = "setTrue" + @counter.to_s
        @counter += 1
        pop()
        @file.write("@SP\n")
        @file.write("A=M-1\n")
        @file.write("D=M-D\n")
        @file.write("@" + setTru + "\n")
        @file.write("D;" + jumpCmd + "\n")
        @file.write("D=0\n")
        @file.write("D=!D\n")
        @file.write("@" + neg + "\n")
        @file.write("0;JMP\n")
        @file.write("(" + setTru + ")\n")
        @file.write("D=0\n")
        @file.write("(" + neg + ")\n")
        @file.write("@SP\n")
        @file.write("A=M-1\n")
        @file.write("M=!D\n")
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
	end

	#current command
	def current()
        return @commands[@counter]
	end

	#return if there are more commands
    def hasMoreCommands()
       return @counter + 1 < @commands.length
	end

	#advance lines
    def advance()
        @counter += 1
        return @commands[@counter]
    end

	#return command type
    def commandType()
        for command in $ARITHMETIC_COMMANDS
            if command == current()
                return $ARITHMETIC
			end
		end
        if /push/.match(current())
            return $PUSH
        elsif /pop/.match(current())
            return $POP
		elsif /label/.match(current())
			return $LABEL
		elsif /goto/.match(current())
			return $GOTO
		elsif /if-goto/.match(current())
			return $IF
		elsif /call/.match(current())
			return $CALL
		elsif /return/.match(current())
			return $RETURN
		elsif /function/.match(current())
			return $FUNCTION
		end
	end

	#return argument 1
    def arg1()
        if commandType() == $RETURN
            raise StandardError("Bad first argument")
		end
        if commandType() == $ARITHMETIC
            result=/\w+/.match(current())
            return result.string
        else
			result = current.gsub(/^\w+\s/, '')
			result = result.gsub(/\d/, '')
			result.strip
			result.chomp
            return result
		end
    end  
       
	#return argument two
    def arg2
        type = commandType()
        if type != $PUSH and type != $POP and type != $FUNCTION and type != $CALL
           raise StandardError("Bad second argument")
		end
		result = current.gsub(/\D+/, '')
		result.chomp
        return result
	end

	#self explanatory
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
		@code.wIn()

		#begin the processing
		@files.each { |file| process_filenames(file) }

		#close the code writer
		@code.close()
	end

	#this actually does the file/dir checking
	def parse_filenames(path)
		#first if checks if it's a directory, a file or neither
		if File.directory?(path)
			dirname = path.chomp
			@files = File.join(path, "*.vm")
			@files = Dir.glob(@files)
			#if we have no files, there's nothing we can do, EXCEPTION
			if (@files.length == 0)
				raise  StandardError, "No files to open"
			end 
			puts @files
			name = File.basename(dirname)
			@output = dirname + "/" + name + ".asm"
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

	#start processing
	def process_filenames(path)
		#objects
		parser = Parser.new(path)
		fname = File.basename(path)
		puts fname
		@code.setFileName(fname)

		#while we have more commands, advance and check command types
		while parser.hasMoreCommands
			parser.advance
			if parser.commandType == $ARITHMETIC
				@code.writeArithmetic(parser.arg1())
			elsif parser.commandType == $PUSH || parser.commandType == $POP
				@code.writePushPop(parser.commandType, parser.arg1(), parser.arg2())
			elsif parser.commandType == $LABEL
				@code.writeLbl(parser.arg1())
			elsif parser.commandType == $GOTO
				@code.writeGo(parser.arg1())
			elsif parser.commandType == $IF
				@code.writeIf(parser.arg1())
			elsif parser.commandType() == $CALL
				@code.writeCall(parser.arg1(), parser.arg2())
			elsif parser.commandType() == $RETURN
				@code.writeRet()
			elsif parser.commandType() == $FUNCTION
				@code.writeFunc(parser.arg1, parser.arg2)
			else 
				raise "Command error"
			end
		end

		#close object
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