#!/bin/sh

# http://www.bashguru.com/2010/01/shell-colors-colorizing-shell-scripts.html

BOILERPLATE_DIR=`pwd`

function log() {
    printf "\033[32m$1\033[0m\n"
}

function error() {
    printf "\033[31m$1\033[0m\n"
}

function info() {
    printf "\033[36m$1\033[0m\n"
}

function welcome() {
cat << "EOF"
  ____                  _     ____        _ _                 _       _
 / ___|_ __ _   _ _ __ | |_  | __ )  ___ (_) | ___ _ __ _ __ | | __ _| |_ ___
| |  _| '__| | | | '_ \| __| |  _ \ / _ \| | |/ _ \ '__| '_ \| |/ _` | __/ _ \
| |_| | |  | |_| | | | | |_  | |_) | (_) | | |  __/ |  | |_) | | (_| | ||  __/
 \____|_|   \__,_|_| |_|\__| |____/ \___/|_|_|\___|_|  | .__/|_|\__,_|\__\___|
                                                       |_|

                                                                        v1.0.0


EOF
}

function checkRequirements() {
    info "Checking requirements..."

    if hash git 2>/dev/null; then
        log "✓ git is installed"
    else
        error "Install git first"
        exit 1;
    fi

    if hash npm 2>/dev/null; then
        log "✓ npm is installed"
    else
        error "Install npm first"
        exit 1;
    fi

    if hash bower 2>/dev/null; then
        log "✓ bower is installed"
    else
        error "Install bower first"
        exit 1;
    fi
}

function setupProjectDir() {
    info "Enter project name: "

    read PROJECT_NAME

    if [ -z "$PROJECT_NAME" ]; then

        setupProjectDir

    elif [ -d "$PROJECT_NAME" ]; then
        error "A project by the name $PROJECT_NAME already exists"

        setupProjectDir

    else
        info "Setting up project: '$PROJECT_NAME'..."
    fi
}

function getProjectRepo() {
    # http://stackoverflow.com/questions/9610131/how-to-check-the-validity-of-a-remote-git-repository-url
    # http://www.cyberciti.biz/faq/how-to-redirect-output-and-errors-to-devnull/

    info "Enter git repository url:"

    read PROJECT_URL

    git ls-remote "$PROJECT_URL" master > /dev/null 2>&1

    # Make sure the return value of ls-remote is 0 or success

    if [ "$?" -ne 0 ]; then
        error "$PROJECT_URL is not a valid git repository or the master branch is not set up yet"

        getProjectRepo

    else
        git clone $PROJECT_URL $PROJECT_NAME
        cd $PROJECT_NAME

        PROJECT_DIR=`pwd`
    fi
}

function migrateSource() {
    info "Migrating source..."

    cd $BOILERPLATE_DIR

    rm -rf .git

    mv ./* $PROJECT_DIR
    mv ./.bowerrc $PROJECT_DIR
    mv ./.gitignore $PROJECT_DIR

    cd $PROJECT_DIR

    info "Cleaning up boilerplate folder..."

    rm -rf $BOILERPLATE_DIR
}

function attemptToBranch() {
    info "Setting up git branches..."

    developExistsOnOrigin=`git ls-remote "$PROJECT_URL" develop | wc -l`

    if [ $developExistsOnOrigin -ne 0 ]; then
        info "Creating a local develop branch based on origin/develop and setting up tracking..."

        git checkout -t origin/develop
    else
        info "develop branch does not exist on origin. Creating one locally and on the origin... "

        git checkout -b develop

        git push -u origin develop
    fi
}

function installDependencies() {
    info "Installing node modules..."

    npm install

    info "Installing bower dependencies..."

    bower install
}

function setupProject() {
    cd ..

    setupProjectDir

    getProjectRepo

    migrateSource

    sed -i '' "s/ENTER_PROJECT_NAME_HERE/$PROJECT_NAME/" package.json
    sed -i '' "s/ENTER_PROJECT_NAME_HERE/$PROJECT_NAME/" bower.json
    sed -i '' "s/ENTER_PROJECT_NAME_HERE/$PROJECT_NAME/" source/jade/index.jade

    attemptToBranch

    installDependencies

    grunt
}

welcome

checkRequirements

setupProject





