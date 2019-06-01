#!/usr/bin/env bash

paste_key_default="]"
paste_key_option="@paste_key"

paste_mouse_key_default="MouseUp2Pane"
paste_mouse_key_option="@paste_mouse_key"

custom_paste_command_default=""
custom_paste_command_option="@custom_paste_command"

override_paste_command_default=""
override_paste_command_option="@override_paste_command"

paste_selection_default="clipboard"
paste_selection_option="@paste_selection"

paste_selection_mouse_default="primary"
paste_selection_mouse_option="@paste_selection_mouse"

# helper functions
get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
      echo "$default_value"
  else
      echo "$option_value"
  fi
}

paste_key() {
  get_tmux_option "$paste_key_option" "$paste_key_default"
}

paste_mouse_key() {
  get_tmux_option "$paste_mouse_key_option" "$paste_mouse_key_default"
}

paste_selection() {
  get_tmux_option "$paste_selection_option" "$paste_selection_default"
}

paste_selection_mouse() {
  get_tmux_option "$paste_selection_mouse_option" "$paste_selection_mouse_default"
}

custom_paste_cmd() {
  get_tmux_option "$custom_paste_command_option" "$custom_paste_command_default"
}

override_paste_cmd() {
  get_tmux_option "$override_paste_command_option" "$override_paste_command_default"
}

# Ensures a message is displayed for 5 seconds in tmux prompt.
# Does not override the 'display-time' tmux option.
display_message() {
  local message="$1"

  # display_duration defaults to 5 seconds, if not passed as an argument
  if [ "$#" -eq 2 ]; then
    local display_duration="$2"
  else
    local display_duration="5000"
  fi

  # saves user-set 'display-time' option
  local saved_display_time
  saved_display_time=$(get_tmux_option "display-time" "750")

  # sets message display time to 5 seconds
  tmux set-option -gq display-time "$display_duration"

  # displays message
  tmux display-message "$message"

  # restores original 'display-time' value
  tmux set-option -gq display-time "$saved_display_time"
}

cmd_exists() {
    local command="$1"
    type "$command" >/dev/null 2>&1
}

clipboard_paste_cmd() {
  # Windows doesn't support getting the clipboard contents by default,
  # clip.exe is only one-way.  Powershell 5 and above do provide a command
  # Get-Clipboard and so that is used here.
  local mouse="${1:-false}"
  if [ -n "$(override_paste_cmd)" ]; then
    override_paste_cmd
  elif cmd_exists "pbpaste"; then
    if cmd_exists "reattach-to-user-namespace"; then
      echo "reattach-to-user-namespace pbpaste"
    else
      echo "pbpaste"
    fi
  elif cmd_exists "powershell.exe"; then # WSL support using powershell
    echo "powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command Get-Clipboard"
  elif [ -n "$DISPLAY" ] && cmd_exists "xsel"; then
    local xsel_selection
    if [[ $mouse == "true" ]]; then
      xsel_selection="$(paste_selection_mouse)"
    else
      xsel_selection="$(paste_selection)"
    fi
    echo "xsel -o --$xsel_selection"
  elif [ -n "$DISPLAY" ] && cmd_exists "xclip"; then
    local xclip_selection
    if [[ $mouse == "true" ]]; then
      xclip_selection="$(paste_selection_mouse)"
    else
      xclip_selection="$(paste_selection)"
    fi
    echo "xclip -o -selection $xclip_selection"
  elif cmd_exists "getclip"; then # cygwin clipboard command
    echo "getclip"
  elif [ -n "$(custom_paste_cmd)" ]; then
    custom_paste_cmd
  fi
}
