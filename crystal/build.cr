require "option_parser"


# if the language is one like crystal, ruby, python then the files
# variable would be equal to the main file where the entery point of the
# program is
flagOptions = ["",""]
version = 1.0
compilerTypes = {kotlin: "kotlinc", c: "gcc", java: "javac", crystal: "crystal", python: "python"}


OptionParser.parse do |parser|
  parser.banner = "A universal build script for many languages"


  parser.on "--build","-b", "build the program, automatically stores the executable in a 'build/' " do
    flagOptions[0] = "build"
    
  end

  parser.on "--run","-r","run the executable in the 'build/' directory" do
    flagOptions[0] = "run"
    
  end

# check for language
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

update(2,"Building all #{options[:language]} files")