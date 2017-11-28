#!/bin/bash
set -e
reposToGet="               \
    JenkinsPipelineCi      \
    "

currentWorkingDirectory=`pwd`
rootRepoDir=${currentWorkingDirectory}/target/repos
rootBackupRepoDir=${currentWorkingDirectory}/target/repos.backup
currentRepoDir=${rootRepoDir}
SECONDS=0

# Clean
echo
echo "*** Clean up any old installation in ${rootRepoDir} and ${rootBackupRepoDir}"
echo
echo
echo
if [ -d ${rootRepoDir} ] ; then
    rm -rf ${rootRepoDir}
fi
if [ -d ${rootBackupRepoDir} ] ; then
    rm -rf ${rootBackupRepoDir}
fi
mkdir -p ${rootRepoDir}
mkdir -p ${rootBackupRepoDir}

# Clone Repo
for repo in ${reposToGet} ; do
    # Init
    #https://stackoverflow.com/questions/5984428/how-to-delete-the-old-history-after-running-git-filter-branch
    currentRepoDir=${rootRepoDir}/${repo}.git
    cd ${rootRepoDir}

    echo
    echo "*** Getting Repo ${repo} to ${currentRepoDir}"
    git clone --mirror https://github.com/patrickeklund/${repo}.git
    echo
    echo
    echo

    # backup Just in case
    echo
    echo "*** Getting Backup from ${currentRepoDir} to ${rootBackupRepoDir}/${repo}.git"
    cp -rf ${currentRepoDir} ${rootBackupRepoDir}/
    echo
    echo
    echo

    # Go into Repo
    cd ${currentRepoDir}

    # Remove remove origin
    echo "*** Remove remove origin"
    git remote rm origin

    # Purge pull requests
    echo
    echo "*** Purge pull requests"
    git show-ref | cut -d' ' -f2 | grep 'pull-request' | xargs --no-run-if-empty -L1 git update-ref -d

    # Purge any none numerical version
    echo
    echo "*** Purge any none numerical version"
    git show-ref --tags | cut -d' ' -f2 | sed 's|refs/tags/[[:digit:]].*||g' | xargs --no-run-if-empty -L1 git update-ref -d

    # Filter away all commiters
    echo
    echo "*** Filter all Authors to anonymous"
    git filter-branch -f --env-filter '
    export GIT_AUTHOR_NAME="anonymous_user"
    export GIT_AUTHOR_EMAIL="anonymous_user@anonymous_user.com"
    export GIT_COMMITTER_NAME="anonymous_user"
    export GIT_COMMITTER_EMAIL="anonymous_user@anonymous_user.com"
    ' --tag-name-filter cat -- --branches --tags
    echo
    echo
    echo


    # Delete backup (from filter)
    echo
    echo "*** Delete backup made from filter request"
    rm -rf refs/original
    echo
    echo
    echo

    # Purge git history of Filter
    echo
    echo "*** Purge git history from any filter request"
    git reflog expire --expire=now --all
    git gc --aggressive --prune=now
    echo
    echo
    echo

    echo
    echo "*** List Repo committers"
    git filter-branch --env-filter '
    echo
    echo GIT_AUTHOR_NAME     [${GIT_AUTHOR_NAME}]
    echo GIT_AUTHOR_EMAIL    [${GIT_AUTHOR_EMAIL}]
    echo GIT_COMMITTER_NAME  [${GIT_COMMITTER_NAME}]
    echo GIT_COMMITTER_EMAIL [${GIT_COMMITTER_EMAIL}]
    ' --tag-name-filter cat -- --branches --tags > ${rootRepoDir}/${repo}.log
    echo
    echo
    echo
done

repoFileDate=`date +%Y-%m-%d`
echo
echo "*** Date used ${repoFileDate}"
echo
echo
echo

# Compress repos
cd ${currentWorkingDirectory}
echo
echo "*** Compress ${rootRepoDir}/*.git to repos-${repoFileDate}.tgz"
echo
echo
echo
cd ${rootRepoDir}
tar -cvzf repos-${repoFileDate}.tgz *.git

ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo
echo
echo
echo "*** Elapsed Time ${ELAPSED}"
echo
