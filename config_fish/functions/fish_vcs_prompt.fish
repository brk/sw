function fish_vcs_prompt --description 'Print all vcs prompts'
    # If a prompt succeeded, we assume that it's printed the correct info.
    # This is so we don't try svn if git already worked.
    fish_jj_prompt_brk $argv
    or fish_git_prompt $argv
    #or fish_hg_prompt $argv
    #or fish_fossil_prompt $argv
end
