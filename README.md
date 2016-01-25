# Grunt boilerplate

## Requirements

1. [Node.js](http://nodejs.org/download/)

2. Bower
    `sudo npm install -g bower`
    
3. Grunt cli
    `sudo npm install -g grunt-cli`
    
4. Permission
    `sudo chown -R $USER ~/.npm`
    
    `sudo chown -R $USER /usr/local/lib/node_modules`
    
    PS: NO need to replace $USER part, that's a linux command to get your user

## How to start a project using this boilerplate

1. Clone the boilerplate repo.
    `git clone git@osage.git.beanstalkapp.com:/osage/grunt-boilerplate.git`
    
2. Inside the project directory, run init_project.sh
    `. init_project.sh`
    
3. DONE! =)
    
   
## Development

Before the front-end developers start messing around in the source code, run

`grunt`

After the templating is done and the front-end package is delivered to the back-end developers, before modifying the source, run

`grunt dev-build`

This grunt task makes sure that any changes on the source code updates the build as well, so that it becomes unnecessary to run `grunt build` 
every time the source is changed by the back-end developers.
   
