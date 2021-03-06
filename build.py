#!/usr/local/bin/python3
import os 
import sys
import shutil 


# The goal of this build script is to create a simple process to
# build files for a language at the moment this language is kotlin
# this script is being made as a simple way to bulid a project without having to
# use a large complex tool like gradle,ant,maven 
# simple commands 
# --build           this will build the directory called src and all files/folders inside of it 
#                   and create a .jar file in a new/pre-existing directory called build 
# --archive         this will create a zip file of the src directory 
# --clean           this will delete the build directory and all contents inside of it 
# --run             this will run the jar file stored in build/
#
#        languages supported 
# --kotlin          builds the src directory for kotlin using the kotlin compiler
#
# build example: artemis --build --kotlin
# this will build the /src/ directory for kotlin 


# things to add
# linking libs to the built .jar file 
# add archive command 
# add classes for the build object this will store the language, output name, and the current working path 

# this is how the command would look 
# with the output command you do not include the .jar extension 
# example: artemis --build --kotlin --output=menu

current_path    = os.getcwd() # get the current working directory you are running the script from 
output_jar_name = ""

# all this function does is check if there is --output= in the last flag 
def check_jar(args):
    global output_jar_name # a global variable defined so i can edit the other global variable 
    try:
        name = args[2]
        if name.count("--output=") != 0:
            output_jar_name = str(name[9:] + ".jar")
            print("[OUTPUT]   :     ",output_jar_name)
        else:
            print_update("incorrectly defined the output flag use '--output=[build name]'\ndo not include the .jar extension on the build name\nusing default build name 'build.jar'",4)
    except IndexError:
        print_update("no output .jar name specified using default name 'build.jar'",4)
        output_jar_name = "build.jar"
#---------------------       END OF METHOD        ------------------------------------

def main(argv):        
    try:
        if argv[0] == "--build":
            check_jar(argv) # check if there was an output name specified 
            build(argv[1]) # pass in the language specified 
        elif argv[0] == "--help": # check for help 
            help()
        elif argv[0] == "--clean": # call the clean function 
            clean()
        elif argv[0] == "--create": # create a project structure 
            create()
        elif argv[0] == "--run":
            run_build()
    except IndexError:
        print_update("No valid flags",2)
#---------------------       END OF METHOD        ------------------------------------




# build the chosen language, at the moment we only support kotlin 
# in the future this shoud hopefully expand to more language 
def build(build_language):
    clean()
    os.chdir(current_path + "/src/")
    all_files = os.listdir()
    files_to_build = []
    #os.chdir(current_path + "/src/") # cd into the src directory 
    print_update("Building all kotlin files",5)
   # print("current directory : ",os.getcwd())
    # check if the language specified is kotlin 
    if build_language != "--kotlin":
        print("at the moment we can only compile kotlin source files, sorry")
        os.chdir(current_path)
        return None
    
    
    # process for building the files 
    # go through the src/ and get a copy of every .kt file in there also check
    # all sub directories in there as well
    # generate a kotlin command with all the correct flags and run it in the terminal 
    # the kotlin compiler will then build a .jar file and put it into the build/ directory 
    # the script is done 
    # maybe add some funky visuals into it for a bit of fun 


    current = ""
   # print(all_files)
   # print("current directory : ",os.getcwd())
    for i in range(len(all_files)):
        current = all_files[i]

        if current[-3:] == ".kt": # check that the last 3 characters of the files is '.kt' if so add 
                                # it to the array of files to build in generate_compile_command()
          #  print(current)
            files_to_build.append(current)

    # check the number of files to build is not 0, print error message if it is
    if len(files_to_build) == 0:
        print_update("There are no kotlin files to build",2)
       # os.system("cd ./..") # exit the src directory
    else:
        generate_compile_command(files_to_build)

#---------------------       END OF METHOD        ------------------------------------




def generate_compile_command(all_file_names):
    compile_command = "kotlinc " # the default compile command
    final_section = "-include-runtime -d " + output_jar_name
    final = ""
    # llop through all the file names and append the file to the end 
    # of the compile command string
    for i in range(len(all_file_names)):
        print_update(str(all_file_names[i]),1)
        compile_command = compile_command + all_file_names[i] + " "

    final = compile_command + final_section
    #print("generated compile command: ",final)
    os.system(final)
    # shift the generated .jar to the build directory
    try:
        shutil.move(current_path + "/src/"+output_jar_name,current_path+"/build/")
        os.chdir(current_path) # shift back up to the main directory 
    except FileNotFoundError:
        print_update("Build failed",2)
    
#---------------------       END OF METHOD        ------------------------------------


# a function that prints updates in a formatted clear way 
def print_update(prompt, update_type):
    if update_type == 1:    # print the name of the compiling file/library
        print("[COMPILING]:     ",prompt)
    elif update_type == 2:  # print if there was an error this could be because there is no src directory to no .kt files found
        print("[ERROR]    :     ",prompt)
    elif update_type == 3:  # print how many files/libraries were compiled into the the jar 
        print("[COMPILED] :     ",prompt)
    elif update_type == 4:
        print("[INFO]     :     ",prompt) # print info about the compile 
    elif update_type == 5:
        print("[BUILD]    :     ",prompt)
    elif update_type == 6:
        print("[CLEAN]    :     ",prompt)
#---------------------       END OF METHOD        ------------------------------------


def help():
    help_words = """
           _____ _______ ______ __  __ _____  _____ 
     /\   |  __ \__   __|  ____|  \/  |_   _|/ ____|
    /  \  | |__) | | |  | |__  | \  / | | | | (___  
   / /\ \ |  _  /  | |  |  __| | |\/| | | |  \___ \ 
  / ____ \| | \ \  | |  | |____| |  | |_| |_ ____) |
 /_/    \_\_|  \_\ |_|  |______|_|  |_|_____|_____/ 
                                                    
                                                    
    USAGE
    artemis [FLAG] [LANGUAGE] [OUTPUT]
    artemis --build --kotlin --output=menu

    FLAGS
    --build         use this flag to build the src/ directory 
    --help          run this flag by itself to get access to this menu 
    --archive       create a copy of the src/ directory and zip it up stores it in another directory called archive/
    --clean         cleans the build in the build directory 
    --create        creates a project structure that is a build, src and archive directory and a readme.md

    OUTPUT FLAGS
    --output=       define the name of the output jar file, if this option is not specified  
                    then the defualt output jar will be 'build.jar'
                    DO NOT add on .jar when defining the name this will be added automatically!!


    LANGUAGES SUPPORTED
    --kotlin        the flag to compile for kotlin 



    """
    print(help_words)


# clean the build directory 
def clean():
    os.chdir(current_path + "/build/")
    files = os.listdir()
    jar_to_clean = ""
    current = ""
     # this will move the current execution path to the build directory 
    for i in range(len(files)):
        current = files[i]
        if current[-4:] == ".jar":
            jar_to_clean = current
            break
    try:
        print_update("Cleaning build directroy",6)
        os.remove(jar_to_clean)
        print_update("Cleaned",6)
        os.chdir(current_path) # shift back up 
    except FileNotFoundError:
        print_update("no .jar to clean",4)
        os.chdir(current_path)
    
# create a couple of directories for the build script 
# this create assumes you are in an emoty directory with no other folders of these names 
def create():
    os.mkdir('build')
    os.mkdir('src')
    os.mkdir('archive')
    f = open("README.md",'w+') # create a file called README.md if it exists clear the file if it doesnt create a new file
    f.write("**Write about your project here**")
    f.close()
    

# run the build that is stored in the build directory 
def run_build():
    os.chdir(current_path + "/build/")
    files = os.listdir()
    current = ""
    for i in range(len(files)):
        current = files[i]
        if current[-4:] == ".jar":
            jar_to_run = current
            break
    os.system("java -jar {0}".format(jar_to_run))
    os.chdir(current_path) # go back up to the main level 
    

    

# enter the main method 
if __name__ == "__main__":
    main(sys.argv[1:])

