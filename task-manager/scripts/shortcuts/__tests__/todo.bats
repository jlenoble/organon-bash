setup() {
    CONTEXT=$(task _get rc.context)
    CONTEXT=${CONTEXT:-none}

    if [ $CONTEXT != none ]; then
        task context none
    fi

    export TASKDATA=$HOME/.task-test
    rm -rf $TASKDATA
}

function teardown() {
    _CONTEXT=$(task _get rc.context)
    _CONTEXT=${_CONTEXT:-none}

    if [ $_CONTEXT != $CONTEXT ]; then
        task context $CONTEXT
    fi
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
    [ $(task count) = 0 ]
    task context none
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "todo" ]
}
