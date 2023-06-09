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

@test "'health A' in context money creates a single task 'A' with tag 'health'" {
    task context money
    health A
    [ $(task count) = 0 ]
    task context health
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "health" ]
}
