#!/usr/bin/env bash

# Treat any non-zero exit codes as fatal.
set -e

# Don't allow unbound variables.
set -u

# Make sure we have a valid location to put our stuff.
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

# Work out where we're putting our script and desktop files.
DESKTOP_PATH=${XDG_DATA_HOME}/applications/vscode-url-handler.desktop
SCRIPT_PATH=${XDG_DATA_HOME}/vscode-url-handler/vscode-url-handler

# Create any directories we need.
mkdir -p "${XDG_DATA_HOME}/"{applications,vscode-url-handler}

# Build the path to use in replacements.
ESCAPED_SCRIPT_PATH=$(echo "${SCRIPT_PATH}" | sed -e "s/[\\/&]/\\\\&/g")

# Copy the URL handler desktop file and substitute the handler path for the absolute path to the handler.
cat vscode-url-handler.desktop | sed "s/%VSCODE_URL_HANDLER%/${ESCAPED_SCRIPT_PATH}/g" > "${DESKTOP_PATH}"

# Copy the URL handler script into it's own folder.
cp vscode-url-handler "${SCRIPT_PATH}"

# Make sure the permissions are right.
chmod a+x "${DESKTOP_PATH}" "${SCRIPT_PATH}"

# Make vscode:// URLs open the handler desktop file we copied.
xdg-mime default vscode-url-handler.desktop x-scheme-handler/vscode
