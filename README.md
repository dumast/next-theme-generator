# Next.js Theme Generator
*Next.js code comes from this website: (https://electricanimals.com/articles/next-js-dark-mode-toggle)[https://electricanimals.com/articles/next-js-dark-mode-toggle]*

## Requirements
* Linux

## What is it?
* This is a simple way to implement a light / dark theme into your Next.js file.
* It creates a switch button that alternated between the two modes when you click on it.
* It uses localstorage so it will keep in memory the last selected theme.

## How to set it up?
* edit the file located here: ~/ .bashrc
* add *source ~/*{path of the file}*/themeselect.bash* at the end of the .bashrc file
  * example: *source ~/Desktop/Scripts/themeselect.bash*
* save and close the file

## How to use it?
* in a nextjs app folder, simply run: 
  * *next-theme*
  * OR
  * *next-theme navbar_file_name theme_toggle_file_name*
* This will create the needed files and install the required dependencies.
* import the Navbar component from the *components* folder wherever you want it, and voila
* *Don't forget to restart the server*

## Side notes
* I wrote the bash file but I didn't create the part that is generated.
* If a *_document.js* file already exists, it will rename the old one to *(OLD)_document.js* and create a new *_document.js* file.
* If you already have a Navbar component, simply copy the importing part of the ThemeToggle file and paste it at the top of your file.
