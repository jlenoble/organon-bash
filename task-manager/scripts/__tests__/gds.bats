setup() {
    export TASKRC=$HOME/.taskrc-test
    cp $HOME/.taskrc $TASKRC

    export TASKDATA=$HOME/.task-test
    rm -rf $TASKDATA
}

@test "'gds A' creates a single task 'A' with tag 'gds'" {
    gds A
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "gds" ]
}

@test "'gds \"A\"'' creates a single task 'A' with tag 'gds'" {
    gds "A"
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "gds" ]
}

@test "'gds A;gds B' create 2 tasks 'A' and 'B' with tag 'gds'" {
    gds A
    gds B
    [ $(task count) = 2 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "gds" ]
    [ $(task _get 2.description) = "B" ]
    [ $(task _get 2.tags) = "gds" ]
}
