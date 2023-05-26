setup() {
    export TASKRC=$HOME/.taskrc-test
    cp $HOME/.taskrc $TASKRC

    export TASKDATA=$HOME/.task-test
    rm -rf $TASKDATA
}

@test "'organon A' creates a single task 'A' with tag 'organon'" {
    organon A
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "organon" ]
}

@test "'organon \"A\"'' creates a single task 'A' with tag 'organon'" {
    organon "A"
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "organon" ]
}

@test "'organon A;organon B' create 2 tasks 'A' and 'B' with tag 'organon'" {
    organon A
    organon B
    [ $(task count) = 2 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "organon" ]
    [ $(task _get 2.description) = "B" ]
    [ $(task _get 2.tags) = "organon" ]
}
