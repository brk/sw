# Place me in ~/.config/fish/functions
# Then add me to `fish_vcs_prompt`: `funced fish_vcs_prompt` and save it to
# your personal config: `funcsave fish_vcs_prompt;`

function fish_jj_prompt_brk --description 'Write out the jj prompt'
    # Is jj installed ?
    if not command -sq jj
        return 1
    end

    # Are we in a jj repo?
    if not jj root --quiet &>/dev/null
        return 1
    end

    # Generate prompt
    jj log --ignore-working-copy --no-graph --color always -r @ -T '
        surround(
            " [",
            "]",
            separate(
                " ",
                bookmarks.join(", "),
                separate("", "@:", change_id.shortest()),
                if(conflict, label("conflict", "(conflict)")),
                if(empty, label("empty", "(empty)")),
                if(divergent, "(divergent)"),
                if(hidden, "(hidden)"),
            )
        )
    '
end
