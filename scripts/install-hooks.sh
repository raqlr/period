#!/usr/bin/env bash
# One-time setup: runs the personal-data check before every commit.
set -e
cd "$(git rev-parse --show-toplevel)"
printf '#!/usr/bin/env bash\nexec scripts/check-no-data.sh\n' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit scripts/check-no-data.sh
echo "Pre-commit data check installed."
