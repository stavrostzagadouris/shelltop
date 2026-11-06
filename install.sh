#!/usr/bin/env sh
# Installs the shtop alias into the current user's shell config.

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
SCRIPT_PATH="$SCRIPT_DIR/shtop"

if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Could not find shtop in $SCRIPT_DIR" >&2
    exit 1
fi
chmod +x "$SCRIPT_PATH"

case "$(basename "${SHELL:-sh}")" in
    zsh)  RC="$HOME/.zshrc";  ALIAS_LINE="alias shtop='$SCRIPT_PATH'" ;;
    fish) RC="$HOME/.config/fish/config.fish"; ALIAS_LINE="alias shtop '$SCRIPT_PATH'" ;;
    *)    RC="$HOME/.bashrc"; ALIAS_LINE="alias shtop='$SCRIPT_PATH'" ;;
esac

mkdir -p "$(dirname "$RC")"
touch "$RC"

if grep -Eq '^[[:space:]]*alias[[:space:]]+shtop[= ]' "$RC"; then
    echo "ℹ 'shtop' alias already exists in $RC"
else
    printf '\n%s\n' "$ALIAS_LINE" >> "$RC"
    echo "✔ Added 'shtop' alias to $RC"
fi

echo "✔ Ready! Open a new terminal (or run: . $RC) and type 'shtop'."
