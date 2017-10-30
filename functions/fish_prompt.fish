function fish_prompt
  set GIT_BRANCH (git branch ^/dev/null | grep \* | sed 's/* //')

  if not test -z $GIT_BRANCH
    set GIT_AHEAD (git_ahead)
    set GIT_MOD (git_porcelain -C)
    set GIT_ORIGIN_STATUS_SYMBOL ✓

    set GIT_COLOR_BG green
    set GIT_COLOR black

    if not test -z "$GIT_AHEAD"
      set GIT_ORIGIN_STATUS_SYMBOL $GIT_AHEAD
    end

    if not test -z "$GIT_MOD"
      # .. we have modifications
      if echo "$GIT_MOD" | grep -q -E '^\s*\d+U\s*$'
        # .. only untracked files
        set GIT_COLOR_BG green
        set GIT_COLOR black
      else
        # .. repository source is somehow modified
        set GIT_COLOR_BG yellow
        set GIT_COLOR black
      end
    end

    # [~/d/myrepo ✓ master ⚡︎]          - ✓ = in sync with origin, working tree clean
    # [~/d/myrepo ✓ master ∆ 1U ⚡︎]     - ✓ = in sync with origin, ∆ 1U = working tree clean  but with 1 untracked file
    # [~/d/myrepo ✓ master ∆ 10M 1D ⚡︎] - ✓ = in sync with origin, ∆ 5M 1D = 5 modified files, 1 deleted
    set_color $GIT_COLOR_BG
    # [~/d/myrepo]
    echo -n -s (prompt_pwd)" "
    set_color -b $GIT_COLOR_BG
    set_color $GIT_COLOR
    # [✓ master]
    echo -n -s " $GIT_ORIGIN_STATUS_SYMBOL $GIT_BRANCH "
    # [∆ 10M 1D]
    if not test -z "$GIT_MOD"
      set_color -b black
      set_color $GIT_COLOR_BG
      echo -n -s " ∆ $GIT_MOD"
    end
    set_color normal
    # [⚡]
    set_color -b black
    set_color $GIT_COLOR_BG
    echo -n -s " ⚡︎ "
    set_color normal
    echo -n -s " "
  else
    # [~/Downloads ⚡︎]
    echo -n -s (prompt_pwd)" "
    set_color -b green
    set_color black
    echo -n -s " ⚡︎ "
    set_color normal;
    echo -n -s " "
  end
end
