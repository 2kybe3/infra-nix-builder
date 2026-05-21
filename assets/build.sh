set -euo pipefail

GREEN="\033[0;32m"
NC="\033[0m"

echo_cmd() {
    echo -e "${GREEN}+ $*${NC}"
}

json=$(cat "$1")
REPO_URL=$(echo "$json" | jq -r '.repo')
TARGET_HOST=$(echo "$json" | jq -r '.host')
TARGET_IP=$(echo "$json" | jq -r '.ip')
TARGET_USER=$(echo "$json" | jq -r '.user')

echo_cmd "BUILD_DIR=\$(mktemp -d /tmp/build-XXXX)"
BUILD_DIR=$(mktemp -d /tmp/build-XXXX)

echo_cmd "trap 'rm -rf \$BUILD_DIR' EXIT"
trap 'rm -rf "$BUILD_DIR"' EXIT

echo_cmd "git clone --depth 1 $REPO_URL $BUILD_DIR"
git clone --depth 1 "$REPO_URL" "$BUILD_DIR"

echo_cmd "cd $BUILD_DIR"
cd "$BUILD_DIR"

echo_cmd "export NIX_SSHOPTS='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"
export NIX_SSHOPTS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo_cmd "nixos-rebuild switch --flake .#$TARGET_HOST --target-host $TARGET_USER@$TARGET_IP --upgrade --verbose"
nixos-rebuild switch \
    --flake ".#$TARGET_HOST" \
    --target-host "$TARGET_USER@$TARGET_IP" \
    --upgrade \
    --verbose
