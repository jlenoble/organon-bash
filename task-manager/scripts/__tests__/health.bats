setup() {
    export TASKRC=$HOME/.taskrc-test
    cp $HOME/.taskrc $TASKRC

    export TASKDATA=$HOME/.task-test
    rm -rf $TASKDATA
}

@test "'health A' creates a single task 'A' with tag 'health'" {
    health A
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "health" ]
}

@test "'health \"A\"'' creates a single task 'A' with tag 'health'" {
    health "A"
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "health" ]
}

@test "'health A;health B' create 2 tasks 'A' and 'B' with tag 'health'" {
    health A
    health B
    [ $(task count) = 2 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "health" ]
    [ $(task _get 2.description) = "B" ]
    [ $(task _get 2.tags) = "health" ]
}
