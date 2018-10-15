

dParams="--build-arg BUILD_DATE=`date -u +\"%Y-%m-%dT%H:%M:%SZ\"` \
  --build-arg VCS_REF=$GIT_SHA1 \
  --build-arg VERSION=$DOCKER_TAG \
  --build-arg PROJECT_NAME=${DOCKER_REPO#*/*}