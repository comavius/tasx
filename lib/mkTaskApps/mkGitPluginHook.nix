# Environment variable GIT_ROOT is set to the root directory of the git repository.
# in-git-root() command takes any number of arguments and runs them in the git root directory.
{}: {gitPlugin, ...}:
if gitPlugin.enable
then ''
  export GIT_ROOT=$(${gitPlugin.program}/bin/git rev-parse --show-toplevel)
  in-git-root() {
    (
      cd "$GIT_ROOT" || exit 1
      "$@"
    )
  }
''
else ""
