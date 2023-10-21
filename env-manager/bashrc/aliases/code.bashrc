. vars/dirs.bashrc

alias codoa='code $PROJECTS_DIR/organon-asm'
alias codob='code $PROJECTS_DIR/organon-bash'
alias codor='code $PROJECTS_DIR/organon-rust'
alias codow='code $PROJECTS_DIR/organon-wagtail'

# Only in a login shell env is NodeJs set up (Gnome doesn't source .profile)
alias codv='bash -lc "code $PROJECTS_DIR/vault"'
