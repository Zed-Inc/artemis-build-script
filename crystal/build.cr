require "option_parser"
require "Dir"
require "./functions"

# if the language is one like crystal, ruby, python then the files
# variable would be equal to the main file where the entery point of the
# program is
flagOptions = [" "," "]
version = 1.0
# store the currently supported compilers and their extension types into these 2 tuples 
compilerTypes =          {kotlin: "kotlinc", c: "gcc",      java: "javac"}
compilerFileExtensions = {kotlin: ".kt",     c: ".c",       java: ".java"} 
validLanguages =         ["kotlin",         "c",           "java"        ]
currentPath = Dir.current
OptionParser.parse do |parser|
  parser.banner = "A universal build script for many languages"


  parser.on "--build","-b", "build the program, automatically stores the executable in a 'build/' " do
    flagOptions[0] = "build"
    
  end

  parser.on "--run","-r","run the executable in the 'build/' directory" do
    flagOptions[0] = "run"
    
  end

  parser.on("--init=PROJNAME", "initalizes a project structure sutiable for this build script"){ |projname| initProject(projname); exit }


  # check for language flag 
  parser.on("--language=LANG", "specify the language you want to build"){ |lang| flagOptions[1] = lang }


  # when the user enters --help or -h it will show the banner and
  # then some information about each command
  parser.on "--help","-h","Shows you the way" do
    puts parser
    exit
  end

  parser.on "-v", "--version", "displays the current build version" do 
    puts "Current build script version: #{version}"
  end 


  parser.invalid_option do |flag|
    update(1,"The flag #{flag} is an invalid option, if you need help use '-h'")
    exit(1)
  end
end

fancyLoadingBar
# create a tuple from the array with all the flag commands in it
options = NamedTuple(command: String, language: String).from({"command" => "#{flagOptions[0]}", "language" => "#{flagOptions[1]}"})

# make a new line, it's a bit nicer 
puts ""

# if there was no language specified, print error and quit execution 
if options[:language] == " " 
  update(1,"There was no build language specified")
  exit
end

# checks if the specified language is valid if not exit the program 
valid = false
validLanguages.each do |lang|
  if lang == options[:language]
    valid = true
  end
end

if valid == false
  update(1,"The language you specified could not be parsed\n\t  Either it was misspelled or it is not currently supported\n\t  Please double check what you typed")
  exit
end

# compileCommand = compilerTypes[options[:language]]
files = getFiles(compilerFileExtensions[options[:language]], currentPath)
# handle if the function returns nil 
if files.size == 0
  update(1,"There were no files of type: #{compilerFileExtensions[options[:language]]} for language #{options[:language]}")
  exit 
end 

filesToCompile = ""
files.each do |file|
  filesToCompile += file
end 

puts "#{compilerTypes[options[:language]]} #{filesToCompile}"