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

@test "'gds A' in context money creates a single task 'A' with tag 'gds'" {
    task context money
    gds A
    [ $(task count) = 0 ]
    task context gds
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "gds" ]
}
