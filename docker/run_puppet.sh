#!/bin/bash -eu

cd /puppet

# Warning this part is highly experiemental, might not work. Sorry, later. :)
if [[ -e ./Puppetfile ]]; then
	echo "Running librarian to handle module dependencies..."
	librarian-puppet install
fi

echo "Applying puppet..."
puppet apply --modulepath modules manifests/local.pp --no-usecacheonfailure --verbose
