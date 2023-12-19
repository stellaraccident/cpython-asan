#!/bin/bash

set -euo pipefail
td="$(cd $(dirname $0) && pwd)"

export PATH="$td/install/bin:$PATH"

echo "python3 = $(which python3)"

echo "Installing asan extension..."
(cd $td/test && python3 setup.py install)


echo "import asan (should pass)..."
python3 -c "import asan"
echo "SUCCESS"
echo ""


echo "Triggering an asan violation. This should fail!"
if python3 -c 'import asan; asan.test(100)'; then
  echo "FAIL (the above should have triggered an asan violation)"
else
  echo "SUCCESS (got the asan violation)"
fi
