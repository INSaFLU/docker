#!/bin/bash
set -e

### several commands
mv /tmp_install/commands /insaflu_web/ && chmod a+x /insaflu_web/commands/*

chown -R ${APP_USER}:${APP_USER} /software && rm -rf /var/lib/apt/lists/*

## entry point
cd / && mv /tmp_install/entrypoint.sh entrypoint_original.sh && sed "s/APP_USER/${APP_USER}/g" entrypoint_original.sh > entrypoint.sh && rm entrypoint_original.sh && chmod a+x entrypoint.sh

## delete the temporary folder
rm -R -f /tmp_install/

