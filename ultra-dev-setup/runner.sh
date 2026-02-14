#!/usr/bin/env bash
set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

LOG_DIR="$BASE_DIR/logs"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/run_$(date +%F_%H-%M-%S).log"

exec > >(tee -a "$LOG_FILE") 2>&1

trap 'echo "❌ Error in module: $CURRENT_MODULE line $LINENO"' ERR

source "$BASE_DIR/lib/common.sh"

MODULES=(
  base_packages.sh
  jetbrains_toolbox.sh
  firefox.sh
  vscode.sh
  brave.sh
  spotify.sh
  docker.sh
  dbeaver.sh
  dev_sysctl.sh
  zram.sh
  gnome_tuning.sh
  shortcuts.sh
)

# ----------------------------------------------------
# MODE SELECTION
# ----------------------------------------------------

echo ""
echo "Select install mode:"
echo "1) Install ALL modules"
echo "2) Ask before each module"
echo ""

read -rp "Enter choice (1 or 2): " MODE

if [[ "$MODE" != "1" && "$MODE" != "2" ]]; then
  echo "Invalid choice"
  exit 1
fi

# ----------------------------------------------------
# RUNNER
# ----------------------------------------------------

run_module() {
  CURRENT_MODULE="$1"
  log "Running $CURRENT_MODULE"
  bash "$BASE_DIR/modules/$CURRENT_MODULE"
}

for module in "${MODULES[@]}"; do

  if [[ "$MODE" == "2" ]]; then
    read -rp "Run $module ? (y/n): " ans
    if [[ ! "$ans" =~ ^[Yy]$ ]]; then
      log "Skipping $module"
      continue
    fi
  fi

  run_module "$module"

done

log "All selected modules completed"
