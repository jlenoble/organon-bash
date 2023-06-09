setup() {
    bats_load_library bats-support
    bats_load_library bats-assert

    source strict-mode
}

function echo_uninitialized_variable() {
    echo before
    echo $var_not_ok
    echo after
}

function fail_right_away() {
    echo "Failed right away"
    exit 1
    echo "Should not be printed"
}

function fail_a_little_later() {
    echo "start"
    fail_right_away
    echo "middle"
    fail_right_away
    echo "end"
}

function grep_missing() {
    grep some-string /non/existent/file
}

function grep_missing_into_sort() {
    grep some-string /non/existent/file | sort
}

function loop_echo {
    names=(
        "one two"
        "three"
        "four five six"
    )

    for name in ${names[@]}; do
        echo "$name"
    done
}

@test "Can use an initialized variable" {
    var_ok=Ok
    echo $var_ok
}

@test "Cannot use a variable before its initialization" {
    run echo_uninitialized_variable
    assert_failure
    assert_output --partial "before"
    refute_output --partial "after"
}

@test "Abort on first failure" {
    # bats relies on set -e being set, so if strict-mode were to be modified (remove set -e or add set +e)
    # then this test would still pass! In other words, our script cannot be tested with bats.

    run fail_right_away
    assert_failure
    assert_output "Failed right away"

    run fail_a_little_later
    assert_failure
    assert_output --partial "start"
    refute_output --partial "middle"
    refute_output --partial "end"
    assert_output "start
Failed right away"
}

@test "Don't mask errors in pipelines" {
    run grep_missing
    assert_failure

    run grep_missing_into_sort
    assert_failure
}

@test "Split on space only when explicitly required" {
    run loop_echo
    assert_success
    assert_output "one two
three
four five six"
}
