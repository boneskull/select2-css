#!/bin/bash

[[ -z `which bower` || -z `which git` || -z `which json` ]] && exit 1;

JSON="/usr/bin/env json"
BOWER="/usr/bin/env bower"
GIT="/usr/bin/env git"
COMPONENTS="./bower_components"
VERSIONS=`${BOWER} info select2 | egrep -o "\d+\.\d+\.\d+$" | uniq | sort -g | xargs`
for VERSION in ${VERSIONS}; do
  [[ -z `${GIT} tag -l "v${VERSION}"` ]] && {
    rm -rf ${COMPONENTS};
    ${BOWER} install select2#${VERSION} && \
	  cp -f ${COMPONENTS}/select2/select2.png . && \
      cp -f ${COMPONENTS}/select2/select2.css . && \
      ${JSON} -I -f bower.json -e "this.version=\"${VERSION}\""
      ${GIT} add ./select2.css ./select2.png ./bower.json && \
      ${GIT} commit -m "version ${VERSION}" && \
      ${GIT} tag -a "v${VERSION}" -m "Release v${VERSION}"
  }
done
