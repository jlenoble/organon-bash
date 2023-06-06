setup() {
    export TASKRC=$HOME/.taskrc-test
    cat $HOME/.taskrc | sed -e '/context=.*/d' >$TASKRC

    export TASKDATA=$HOME/.task-test
    rm -rf $TASKDATA
}

@test "'todo A' creates a single task 'A' with tag 'todo'" {
    todo A
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "todo" ]
}

@test "'todo \"A\"'' creates a single task 'A' with tag 'todo'" {
    todo "A"
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "todo" ]
}

@test "'todo A;todo B' create 2 tasks 'A' and 'B' with tag 'todo'" {
    todo A
    todo B
    [ $(task count) = 2 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "todo" ]
    [ $(task _get 2.description) = "B" ]
    [ $(task _get 2.tags) = "todo" ]
}

@test "'todo A' in context money creates a single task 'A' with tag 'todo'" {
    task context money
    todo A
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "todo" ]
}
