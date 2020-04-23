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
