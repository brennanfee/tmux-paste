#!/user/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS_DIR="${CURRENT_DIR}/scripts"

# shellcheck source=scripts/helpers.sh
source "${HELPERS_DIR}/helpers.sh"

set_paste_error_bindings() {
  local key_set
  local mouse_key_set
  key_set="$(paste_key)"
  mouse_key_set="$(paste_mouse_key)"

  if [[ ! -z "$mouse_key_set" ]]; then
    tmux bind-key -T root "$mouse_key_set" display-message "Error! tmux-paste dependencies not installed!"
  fi
  # Don't change the default for ] as it should still work within tmux
  if [[ ! -z "$key_set" && ! "$key_set" == ']' ]]; then
    tmux bind-key "$key_set" display-message "Error! tmux-paste dependencies not installed!"
  fi
}

error_handling_if_paste_cmd_not_present() {
  local paste_command="$1"
  if [[ -z "$paste_command" ]]; then
    set_paste_error_bindings
    exit 0
  fi
}

set_paste_bindings() {
  local key_set
  local mouse_key_set
  key_set="$(paste_key)"
  mouse_key_set="$(paste_mouse_key)"
  local paste_command="$1"

  # shellcheck disable=SC2016
  local set_buffer='tmux set-buffer $('
  local paste_buffer='); tmux paste-buffer'

  if [[ ! -z "$mouse_key_set" ]]; then
    tmux bind-key -T root "$mouse_key_set" run-shell -b "$set_buffer$paste_command$paste_buffer"
  fi

  if [[ ! -z "$key_set" ]]; then
    tmux bind-key "$key_set" run-shell -b "$set_buffer$paste_command$paste_buffer"
  fi
}

main() {
  local paste_command
  # shellcheck disable=SC2119
  paste_command="$(clipboard_paste_cmd)"
  error_handling_if_paste_cmd_not_present "$paste_command"
  set_paste_bindings "$paste_command"
}
main
