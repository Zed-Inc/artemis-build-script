require "option_parser"


# if the language is one like crystal, ruby, python then the files
# variable would be equal to the main file where the entery point of the
# program is
options = {language: "", command: "", files: ""}

Option_parser.parse do |parser|
  parser.banner = "A universal build script for many languages"


  parser.on "--build","-b", "buld the program"do
    options[:command] = "build"
    exit
  end

  parser.on "--language","-l", "specify the language you want to build" do
    
  end

# when the user enters --help or -h it will show the banner and
# then some information about each command
  parser.on "--help","-h","Shows you the way" do
    puts parser
    exit
  end

end
