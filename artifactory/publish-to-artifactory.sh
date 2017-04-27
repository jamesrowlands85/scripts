#!/bin/bash

help() {
  cat >&2 << EOF

Deploy to Artifactory

OPTIONS
  -k API KEY
    The API Key that will be used to deploy to artifactory

  -f FILE
    The file we want to upload to artifactory, can be a directory.

    This will also be the directory/file structure within the destination URL

  -u URL
    The artifactory URL we want to publish to

  -h HELP
    Print this help information

EXAMPLES

  The following will publish the test direcory and its contents to the artifactory url

  ./publish-to-artifactory -k <Artifactory API Key> -f <File or Directory to Publish -u <Artifactory Url>

EOF
}

while getopts ":k:f:u:h" option
do
  case "${option}" in
    k) KEY=${OPTARG};;
    f) FILE=${OPTARG};;
    u) URL=${OPTARG};;
    h) help
       exit 0;;
  esac
done

# remove a trailing slash from the url if it exists
URL=${URL%/}

# return value
retval = 0

# upload to artifactory
curl --insecure -H 'X-JFrog-Art-Api: '$KEY'' -T $FILE "$URL/$FILE"

retval=$(( $retval + $? ))

echo ""
echo "================================================================================"
echo ""
echo "Finished publish to artifactory attempt with return code $retval"
echo ""
echo "Attempted to deploy file/directory $FILE"
echo "To $URL"
echo ""
echo "================================================================================"

exit $retval
