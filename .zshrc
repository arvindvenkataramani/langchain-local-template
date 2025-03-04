# Only set custom prompt when in virtualenv
echo "DEBUG: VIRTUAL_ENV=$VIRTUAL_ENV"
echo "DEBUG: PROJECT_NAME=$PROJECT_NAME"
if [[ -n $VIRTUAL_ENV ]]; then
  # Extract just the project name from virtualenv path
  PROJECT_NAME=$(basename $(dirname $VIRTUAL_ENV))
  # Set prompt with just project name, current directory name only, and > symbol
  PROMPT="${PROJECT_NAME} %F{cyan}%1~%f > "
fi