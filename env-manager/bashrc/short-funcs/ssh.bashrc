# Connect locally as $1 user
s() {
    ssh -X $1@localhost
}

# Launch Firefox as $1 user
sfirefox() {
    user=$1
    shift
    ssh -X $user@localhost firefox $@
}

# Launch Keepass2 as $1 user
skeepass2() {
    user=$1
    shift
    ssh -X $user@localhost keepass2 $@
}
