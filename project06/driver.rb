inFile = File.open(ARGV[0],'r');

if File.fnmatch('*', '.asm', File::FNM_DOTMATCH) 
	puts "Success in finding file"
else
	puts "File doesn't exist, proper argument was not supplied or invalid file name given"
	Process.exit
end
of = ARGV[0] + ".hack"
outFile = File.open(of, 'w');
inFile.close
outFile.close