require "colorize"

# initalize project structure that is suitable for the script 
def initProject(projectName)
  currentDirectory = Dir.current # get the current working directory 
  newPath = currentDirectory + "/#{projectName}" # generate the new path name 
  Dir.mkdir(newPath)
  Dir.cd(newPath) # cd into the newly created directory 
  # create 3 new directories for the project
  Dir.mkdir("build")
  update(1,"creating 'build' directory")
  Dir.mkdir("src")
  update(1,"creating 'src' directory ")
  Dir.mkdir("archive")
  update(1,"creating 'archive' directory")
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

# gets all the files needed and returns the array
def getFiles(filetype, path)
 # puts "Searching on #{path} for all #{filetype} files types"
  files = Dir.[]("*#{filetype}")
  return files
end


def fancyLoadingBar()
  currPos = 11
  puts "fancy bar"
  # \033[L;CH
  # move cursor to coloumn C line L
  puts "\033[15;10H {"
  puts "\033[15;22H }"
  while currPos <= 21
    puts "\033[15;#{currPos}H•"
    currPos += 1
    sleep 0.5
  end
  puts "\033[16;0H end of loop, pos value #{currPos}"
end