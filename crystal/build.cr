require "option_parser"
require "Dir"

# if the language is one like crystal, ruby, python then the files
# variable would be equal to the main file where the entery point of the
# program is
flagOptions = [" "," "]
version = 1.0
# store the currently supported compilers and their extension types into these 2 tuples 
compilerTypes =           {kotlin: "kotlinc", c: "gcc", java: "javac", crystal: "crystal", python: "python"}
compilerFileExtensionss = {kotlin: ".kt", c: ".c", java: ".java", crystal: ".cr", python: ".py"} 


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

  parser.on "-v", "--version" do 
    puts "Current build script version: #{version}"
  end 


  parser.invalid_option do |flag|
    update(1,"The flag #{flag} is an invalid option, if you need help use '-h'")
    exit(1)
  end
end

# basic update functionality, makes the strings a bit cleaner and uniform
def update(updateType, update)
  if updateType == 1
    puts "[ERROR]   #{update}"
  end
  if updateType == 2
    puts "[INFO]    #{update}"
  end
end

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
if options[:language] != compilerTypes
  update(1,"The language you specified could not be parsed\n\t  Either it was misspelled or it is not currently supported\n\t  Please double check the command")
  exit
end

# pass in the named tuples to the function
compileLine = runCommand(**options)

# returns a string with the correct compile type 

# find the correct compile type from the tuples 
# concatnate that to the string 
# search the directory for files ending in the type name 
#
def runCommand(commands)
  compileFor = commands.fetch(:language,"Unknown") # get us the language we want to use for the build 
  compile = "#{compilerTypes[compileFor]} "
  

  return compile
end




def initProject(projectName)
  currentDirectory = Dir.current # get the current working directory 
  newPath = currentDirectory + "/#{projectName}" # generate the new path name 
  dir = Dir.new(currentDirectory) # create a new Dir object
  dir.mkdir(newPath)
  dir.cd(newPath) # cd into the newly created directory 
  # create 3 new directories for the project
  dir.mkdir("build")
  update(1,"creating 'build' directory")
  dir.mkdir("src")
  update(1,"creating 'src' directory ")
  dir.mkdir("archive")
  update(1,"creating 'archive' directory")


end