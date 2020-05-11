#!/bin/bash
set -euf -o pipefail

aws secretsmanager get-secret-value ${2-} ${3-} --secret-id ssh/${1} --query SecretString \
   | sed 's/"//g' | sed 's/\\n/\
/g' | sed -e '$ d' > ${1}
