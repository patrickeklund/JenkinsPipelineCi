#!/bin/bash
set -e
#https://gist.github.com/matzegebbe/a2678b227add6bafad9a3a802618b5ad
REPO_URL="https://<nexus docker repo>/repository/"
USER="<username>"
PASSWORD="<password>"

BUCKET="<nexus repo name>"
TAG_TO_REMOVE="\\-SNAPSHOT"
KEEP_IMAGES=10

# Get all Images related to a Repo
IMAGES=$(curl --silent --insecure -X GET -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -u ${USER}:${PASSWORD} "${REPO_URL}${BUCKET}/v2/_catalog" | jq .repositories | jq -r '.[]' )
#echo "**** Images ${IMAGES}"

for IMAGE_NAME in ${IMAGES}; do
    echo "**** ${IMAGE_NAME}"

    # Get all Tags for the Image
    TAGS=$(curl --silent --insecure  -X GET -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -u ${USER}:${PASSWORD} "${REPO_URL}${BUCKET}/v2/${IMAGE_NAME}/tags/list" | jq .tags | jq -r '.[]' )
    ONLY_SNAPSHOTS_TAGS=""

    # Remove any none SNAPSHOT Tag
    for TAG in ${TAGS} ; do
        if ( echo ${TAG} | grep ${TAG_TO_REMOVE} ) ; then
            ONLY_SNAPSHOTS_TAGS="${ONLY_SNAPSHOTS_TAGS} ${TAG}"
        fi
    done
#    echo "**** Found SNAPSHOT tags: ${ONLY_SNAPSHOTS_TAGS}"

    for TAG in ${ONLY_SNAPSHOTS_TAGS} ; do
        echo "**** Removing SNAPSHOT tag: ${TAG}"
        IMAGE_SHA=$(curl --silent --insecure -I -X GET -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -u ${USER}:${PASSWORD} "${REPO_URL}${BUCKET}/v2/${IMAGE_NAME}/manifests/$TAG" | grep Docker-Content-Digest | cut -d ":" -f3 | tr -d '\r')
        DEL_URL="${REPO_URL}${BUCKET}/v2/${IMAGE_NAME}/manifests/sha256:${IMAGE_SHA}"
        echo "**** DELETE ${TAG} ${IMAGE_SHA} ${DEL_URL}"
        RET="$(curl --silent --insecure -k -X DELETE -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -u ${USER}:${PASSWORD} $DEL_URL)"
    done

done
