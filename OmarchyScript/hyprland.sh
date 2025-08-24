#!/bin/bash

echo
read -rp "Do you want to apply custom Hyprland configs? (y/n): " answer

if [[ ! "$answer" =~ ^[Yy]$ ]]; then
  echo "❌ Skipping Hyprland config setup."
  exit 0
fi

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
LOCAL_CONFIG="$SCRIPT_DIR/hyprlandoverride.conf"
TARGET_CONFIG="$HOME/.config/hypr/hyprlandoverride.conf"
MAIN_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Create target config directory if it doesn't exist
mkdir -p "$(dirname "$TARGET_CONFIG")"

# Apply (overwrite) the override config
echo "⚙️  Applying Hyprland override config..."
cp "$LOCAL_CONFIG" "$TARGET_CONFIG"

# Create main Hyprland config if it doesn't exist
if [[ ! -f "$MAIN_CONFIG" ]]; then
  echo "⚠️  Main Hyprland config not found at: $MAIN_CONFIG"
  echo "📝 Creating it and adding source command..."
  echo "source = $TARGET_CONFIG" >"$MAIN_CONFIG"
else
  # Add source line only if it's not already present
  if ! grep -Fxq "source = $TARGET_CONFIG" "$MAIN_CONFIG"; then
    echo "⚙️  Adding source command to main Hyprland config..."
    echo "source = $TARGET_CONFIG" >>"$MAIN_CONFIG"
  else
    echo "✅ Source command already exists in main config."
  fi
fi

echo "✅ Hyprland config setup complete."
