#!/usr/bin/env sh

${VERBOSE} && set -x

# Set PATH - since this is executed from within the server process, it may not have all we need on the path
export PATH="${PATH}:${SERVER_ROOT_DIR}/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${JAVA_HOME}/bin"

if test -f "${STAGING_DIR}/artifacts/artifact-list.json"; then

  # Check to see if the artifact file is empty
  ARTIFACT_LIST_JSON=$(cat "${STAGING_DIR}/artifacts/artifact-list.json")
  # Check to see if the source S3 bucket is specified
  if test ! -z "${ARTIFACT_LIST_JSON}"; then
    if test ! -z "${ARTIFACT_REPO_URL}"; then

      echo "Downloading from location ${ARTIFACT_REPO_URL}"

      # Install AWS CLI if the upload location is S3
      #if test "${ARTIFACT_REPO_URL#s3}" == "${ARTIFACT_REPO_URL}"; then
      #  echo "Upload location is not S3"
      #  exit 0
      #elif ! which aws > /dev/null; then
      #  echo "Installing AWS CLI"
      #  apk --update add python3
      #  pip3 install --no-cache-dir --upgrade pip
      #  pip3 install --no-cache-dir --upgrade awscli
      #fi

      if ! which jq > /dev/null; then
        echo "Installing jq"
        pip3 install --no-cache-dir --upgrade jq
      fi

      if ! which unzip > /dev/null; then
        echo "Installing unzip"
        pip3 install --no-cache-dir --upgrade unzip
      fi

      DIRECTORY_NAME=$(echo ${PING_PRODUCT} | tr '[:upper:]' '[:lower:]')

      if [ -z "${ARTIFACT_REPO_URL##*/pingfederate*}" ] ; then
        TARGET_BASE_URL="${ARTIFACT_REPO_URL}"
      else
        TARGET_BASE_URL="${ARTIFACT_REPO_URL}/${DIRECTORY_NAME}"
      fi

      for artifact in $(echo "${ARTIFACT_LIST_JSON}" | jq -c '.[]'); do
        _artifact() {
          echo ${artifact} | jq -r ${1}
        }

        ARTIFACT_NAME=$(_artifact '.name')
        ARTIFACT_VERSION=$(_artifact '.version')


        # Download artifact zip
        curl "${TARGET_BASE_URL}/${ARTIFACT_NAME}/${ARTIFACT_VERSION})/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.zip" --output /tmp/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.zip

        if test $(echo $?) == "0"; then
          CURRENT_DIRECTORY=$(pwd)
          cd "${OUT_DIR}/instance/server/default"
          unzip "/tmp/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.zip" 2> ${OUT_DIR}/error.txt
          rm /tmp/${ARTIFACT_NAME}-${ARTIFACT_VERSION}.zip
          cd ${CURRENT_DIRECTORY}
        fi

        #if [ ! -z "$(aws s3 ls ${TARGET_BASE_URL}/${ARTIFACT_NAME}/${ARTIFACT_VERSION})" ]
        #then
        #  aws s3 cp "${TARGET_BASE_URL}/${ARTIFACT_NAME}/${ARTIFACT_VERSION}/" "${OUT_DIR}/instance/server/default" --recursive
        #fi

      done

      # Print listed files from deploy
      ls ${OUT_DIR}/instance/server/default/deploy
      ls ${OUT_DIR}/instance/server/default/conf/template

    fi
  fi
fi
