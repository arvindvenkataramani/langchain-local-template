# Only set custom prompt when in virtualenv
if [[ -n $VIRTUAL_ENV ]]; then
  # Set prompt without project name (VS Code already adds it)
  PROMPT=" %F{cyan}%1~%f > "
fi