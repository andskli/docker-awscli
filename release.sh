#!/bin/bash

set -eo pipefail

LATEST_VERSION=$(curl -qsSL https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[0].name' | grep -E '(\d+)\.(\d+)\.(\d+)')

echo -n "Release version [${LATEST_VERSION}]: "
read release_version

if [ "x${release_version}" == "x" ]; then
    release_version=$LATEST_VERSION
fi

# Replace the env var in the docker file
sed -i.old "s!^\(ENV AWSCLI_VERSION\) \(.*\)\$!\1 ${release_version}!g" Dockerfile

echo "Dockerfile updated to version ${release_version}"
echo "git: commiting and tagging"
(
    git add Dockerfile && \
    git commit -m"Updated to version ${release_version}" && \
    git tag -a ${release_version} -m"Version ${release_version} of AWS CLI"
)

echo -n "Push to github? (y/n)"
read push_gh

if [ "x${push_gh}" == "xy" ]; then
    git push origin ${release_version}
fi