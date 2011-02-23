instr = ARGV[0]
inFile = File.open(instr,'r');

if File.fnmatch('*', '.asm', File::FNM_DOTMATCH) 
	puts "Success in finding file"
	of = instr.dup
	of["asm"] = "hack"
	outFile = File.open(of, 'w');
	inFile.close
	outFile.close
else
	puts "File doesn't exist, proper argument was not supplied or invalid file name given"
	Process.exit
end
