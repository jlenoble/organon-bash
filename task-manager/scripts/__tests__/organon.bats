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

@test "'organon A' in context money creates a single task 'A' with tag 'organon'" {
    task context money
    organon A
    [ $(task count) = 0 ]
    task context organon
    [ $(task count) = 1 ]
    [ $(task _get 1.description) = "A" ]
    [ $(task _get 1.tags) = "organon" ]
}
