#!/bin/bash

set -e

HYPRLAND_CONFIG="$HOME/.config/hypr/hyprland.conf"
DEST_CONFIG_DIR="$HOME/.config/hypr"
OVERRIDES_FILENAME="hyprlandoverride.conf"
DEST_OVERRIDES_CONFIG="$DEST_CONFIG_DIR/$OVERRIDES_FILENAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_LINE="source = $DEST_OVERRIDES_CONFIG"

# Prompt the user for confirmation
read -p "Do you want to apply the Hyprland override configuration? (y/n): " USER_RESPONSE
case "$USER_RESPONSE" in
[yY][eE][sS] | [yY])
  echo "Proceeding with configuration..."
  ;;
*)
  echo "Aborted by user."
  exit 0
  ;;
esac

# Check if hyprland config exists
if [ ! -f "$HYPRLAND_CONFIG" ]; then
  echo "Hyprland config not found at $HYPRLAND_CONFIG"
  echo "Please install hyprland first"
  exit 1
fi

# Check if overrides config exists in script directory
if [ ! -f "$SCRIPT_DIR/$OVERRIDES_FILENAME" ]; then
  echo "Overrides config not found at $SCRIPT_DIR/$OVERRIDES_FILENAME"
  exit 1
fi

# Check if source line already exists in hyprland.conf
if grep -Fxq "$SOURCE_LINE" "$HYPRLAND_CONFIG"; then
  echo "Source line already exists in $HYPRLAND_CONFIG"
else
  echo "Adding source line to $HYPRLAND_CONFIG"
  echo "" >>"$HYPRLAND_CONFIG"
  echo "$SOURCE_LINE" >>"$HYPRLAND_CONFIG"
  echo "Source line added successfully"
fi

# Copy the override file to the hypr config directory
echo "Copying $OVERRIDES_FILENAME to $DEST_CONFIG_DIR"
cp "$SCRIPT_DIR/$OVERRIDES_FILENAME" "$DEST_OVERRIDES_CONFIG"
echo "Overrides config copied successfully"

echo "Hyprland overrides setup complete!"
