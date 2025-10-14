_comp_cmd_git_keeper()
{
  local cur prev words cword
  _get_comp_words_by_ref cur prev words cword
  word1="${COMP_WORDS[1]}"
  COMPREPLY=()

  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=( $(compgen -W "status commit update vcs ls diff help" -- "$cur") )
    return 0
  elif [ $COMP_CWORD -eq 2 ]; then
    case "$word1" in
      status|commit|update|vcs|diff)
        local options
        if options="$(git-keeper ls </dev/null 2>/dev/null)"; then
          COMPREPLY=( $(compgen -W "${options}" -- ${cur}) )
        else
          COMPREPLY=()
        fi
        return 0
        ;;
    esac
  elif [ $COMP_CWORD -ge 3 ]; then
    case "$word1" in
      vcs)
        . /usr/share/bash-completion/completions/git
        COMP_LINE="git ${COMP_WORDS[*]:3}"
        COMP_WORDS=( git "${COMP_WORDS[@]:3}" )
        ((COMP_CWORD -= 2))
        __git_wrap__git_main
        ;;
    esac
  fi
} && complete -o bashdefault -o default -o nospace -F _comp_cmd_git_keeper git-keeper

_comp_cmd_gitkp()
{
  . /usr/share/bash-completion/completions/git
  COMP_LINE="git ${COMP_WORDS[*]:1}"
  COMP_WORDS=( git "${COMP_WORDS[@]:1}" )
  __git_wrap__git_main
} && complete -o bashdefault -o default -o nospace -F _comp_cmd_gitkp gitkp
