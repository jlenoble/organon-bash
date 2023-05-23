# Task UDAs

# subtask_of

To be distinguished from predefined `depends`. A task may have prerequisites and/or
subtasks.

The latter are constitutive of it. The task is complete iff all its parts are complete.

The former are anterior to it. The task cannot start until all its prerequisites are complete.

In terms of `task`, the latter is represented by `uda.subtask_of`, the former by `depends`.

Changing the status of a dependency (prerequite) doesn't affect the status of a task,
changing the status od a substask does. 