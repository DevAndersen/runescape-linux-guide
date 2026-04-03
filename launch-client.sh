#!/bin/sh

# Helper script which tells Bolt how to launch RuneScape installed with Bottles.

# Change the launch command for RS3 in Bolt to run this script.
# Example: /bin/sh /home/USERNAME/Games/RuneScape/Linux/launch-client.sh
# Note: This must be the fully qualified path. Bolt does not support "$HOME" or "~" as substitutes for the user's home directory.

# The name of the RuneScape bottle.
# Note: This is case sensitive, and must be an exact match of the name of the bottle you created in the Bottles application.
BOTTLE_NAME="RuneScape"

# Determine the user's home directory on the host.
HOST_HOME="$(/bin/flatpak-spawn --host /bin/sh -c 'printf "%s\n" "$HOME"')"

# The Bottles data directory.
# Note: Change this if Bottles has been installed in a non-default location.
BOTTLES_DATA_DIRECTORY="$HOST_HOME/.var/app/com.usebottles.bottles/data/bottles"

# The Wine prefix (the root directory of the Wine environment) where RuneScape is installed.
WINEPREFIX="$BOTTLES_DATA_DIRECTORY/bottles/$BOTTLE_NAME"

# Read the bottle's config file, and find the name of the runner.
RUNNER_NAME=$(sed -n 's/^Runner: //p' "$WINEPREFIX/bottle.yml")

# The Wine executable for the specified runner.
WINE="$BOTTLES_DATA_DIRECTORY/runners/$RUNNER_NAME/bin/wine64"

# The RuneScape game client.
# Note: This assumes you did not change anything when installing "RuneScape-Setup.exe" with Bottles.
RUNESCAPE_CLIENT="$WINEPREFIX/drive_c/Program Files/Jagex/RuneScape Launcher/RuneScape.exe"

# Launches the game client.
# - Run a process on the host.
# - Pass the Jagex authentication credential environment variables from Bolt (JX_DISPLAY_NAME is not necessary for authentication to work).
# - Specify the Wine prefix.
# - Run the RuneScape client, using the specified Wine runner.
/bin/flatpak-spawn \
 --host \
 --env=JX_DISPLAY_NAME="$JX_DISPLAY_NAME" \
 --env=JX_CHARACTER_ID="$JX_CHARACTER_ID" \
 --env=JX_SESSION_ID="$JX_SESSION_ID" \
 --env=WINEPREFIX="$WINEPREFIX" \
 "$WINE" "$RUNESCAPE_CLIENT"
