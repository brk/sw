
set --prepend PATH $HOME/sw/bin
set --prepend PATH $HOME/.local/bin

# Anything in config.fish that produces output should be guarded 
# with `status is-interactive`
status is-interactive || exit

set -x EDITOR vim

# Function for ignoring the first 'n' lines
# ex: seq 10 | skip 5
# results: prints everything but the first 5 lines
function skip --argument n
    tail +(math 1 + $n)
end

# Function for taking the first 'n' lines
# ex: seq 10 | take 5
# results: prints only the first 5 lines
function take --argument number
    head -$number
end

