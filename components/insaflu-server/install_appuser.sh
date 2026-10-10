#!/bin/bash
# components/insaflu-server/install_appuser.sh
# Creates the account the application runs as.

set -e

useradd -ms /bin/bash ${APP_USER}
