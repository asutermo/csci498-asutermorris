instr = ARGV[0] #accept arg via command line, hopefully this is *.asm
inFile = File.open(instr,'r') if File::exists?(instr) #attempt to open file

if File.fnmatch('*.asm', instr, File::FNM_DOTMATCH) #if the file is actually an assembly file
	puts "Success in finding file"	#test output to verify success
	of = instr.dup					#was having issues with "frozen" string, so duplicate it
	of["asm"] = "hack"				#replace the .asm with .hack
	outFile = File.open(of, 'w');	#create the .hack file
	inFile.close					#close input stream
	outFile.close					#close output stream
else
	puts "File doesn't exist, proper argument was not supplied or invalid file name given" #fail-cake. file not opened properly
	Process.exit					#exit
end
