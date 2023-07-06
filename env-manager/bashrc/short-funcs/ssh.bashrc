# Connect locally as $1 user
s() {
    ssh -X $1@localhost
}

# Launch VS Code as $1 user
# If $2 is provided, open folder /home/$1/$2; default is /home/$1/Documents
scode() {
    user=$1
    shift
    folder=${1:-Documents}
    shift
    code --remote ssh-remote+$user@localhost "/home/$user/$folder" $@
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

# Launch KMyMoney as $1 user
skmymoney() {
    user=$1
    shift
    ssh -X $user@localhost kmymoney $@
}
