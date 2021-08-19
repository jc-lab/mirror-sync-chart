#!/bin/bash

# Environment Variables
# - MIRROR_NAME
# - SERVER_SVC_NAME

mirror_name=${MIRROR_NAME}
dest_name="$(yq r /mirrors/${mirror_name}.yaml 'destination')"
rsync_uris="$(yq r /mirrors/${mirror_name}.yaml 'rsync.*')"

temp_script=$(mktemp)
cat << EOF | tee ${temp_script}
#!/bin/bash
set -eu
rc=1
for uri in \$(echo "${rsync_uris}"); do
  echo \${uri}
  rsync -avz \${uri} "\$HOME/${dest_name}"
  rc=\$?
  [ ! \$rc -eq 0 ] || break
done
[ \$rc -eq 0 ] && echo "SUCCESS" || echo "FAIL: \$rc"
EOF

scp -o StrictHostKeyChecking=accept-new -i /ssh-private/private "${temp_script}" "updater@${SERVER_SVC_NAME}:${temp_script}"
ssh -o StrictHostKeyChecking=accept-new -i /ssh-private/private updater@${SERVER_SVC_NAME} "chmod +x ${temp_script} && ${temp_script}"

