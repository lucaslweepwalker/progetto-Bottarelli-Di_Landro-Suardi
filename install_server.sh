#!/bin/bash

# =============================================================================
# install_server.sh  –  Setup simulazione server intranet
# =============================================================================

SERVER_ROOT="/workspaces/codespaces-blank/progetto-Bottarelli-Di_Landro-Suardi/intranet_sim"
SCRIPTS_DIR="/workspaces/codespaces-blank/progetto-Bottarelli-Di_Landro-Suardi"
ACCESS_LOG="$SERVER_ROOT/logs/access.log"
WHITELIST="$SERVER_ROOT/config/whitelist.conf"

echo "Building Simulated Server at $SERVER_ROOT..."

mkdir -p "$SERVER_ROOT/data" \
         "$SERVER_ROOT/config" \
         "$SERVER_ROOT/logs" \
         "$SERVER_ROOT/logs/archive" \
         "$SERVER_ROOT/logs_output"

python3 -m pip install -q --upgrade pip
pip install -q numpy

# Configurazione degli orari notturni
echo "START_HOUR=6"  > "$SERVER_ROOT/config/settings.conf"
echo "END_HOUR=21"  >> "$SERVER_ROOT/config/settings.conf"

python3 "$SCRIPTS_DIR/create_users.py"

python3 "$SCRIPTS_DIR/create_accesslog.py"

awk -F "|" '{print $3}' "$ACCESS_LOG" | sort -u | shuf -n 96 > "$WHITELIST"

echo ""
echo "Server Simulation Ready."
echo "  data/users.csv        -> $(wc -l < "$SERVER_ROOT/data/users.csv") righe"
echo "  logs/access.log       -> $(wc -l < "$ACCESS_LOG") righe"
echo "  config/whitelist.conf -> $(wc -l < "$WHITELIST") IP"

chmod +x "$SCRIPTS_DIR/manuale.sh"
sudo cp "$SCRIPTS_DIR/manuale.sh" /usr/local/bin/manuale