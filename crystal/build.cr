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

  parser.on "--run","-r","run the executable in the 'build/' directory" do
    options[:command] = "run"
    exit
  end

# check for language
  parser.on "--language=LANG","-l=LANG", "specify the language you want to build" do
    |lang| options[:language] = lang
    exit
  end

# when the user enters --help or -h it will show the banner and
# then some information about each command
  parser.on "--help","-h","Shows you the way" do
    puts parser
    exit
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
end
