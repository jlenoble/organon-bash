# Task scripts

## achieve

```bash
task
# ID Age Tag   Description      Urg 
#  1  8s chore Do the dishes    5.8
#  2  5s chore Wash the laundry 5.8
#  3  1s chore Go shopping      5.8
achieve
task
# ID Age Tag   Description      Urg
#  1  8s chore Wash the laundry 5.8
#  2  4s chore Go shopping      5.8
achieve 2
# ID Age Tag   Description      Urg
#  1 11s chore Wash the laundry 5.8
```

## chore

```bash
chore Do the dishes
# Created task 1.
task
# ID Age Tag   Description   Urg 
#  1  1s chore Do the dishes 5.8
todo Wash the laundry
# Created task 2.
task
# ID Age Tag   Description      Urg 
#  1  4s chore Do the dishes    5.8
#  2  1s todo  Wash the laundry 0.8
chore 2
# Modifying task 2 'Wash the laundry'.
# Modified 1 task.
task
# ID Age Tag   Description      Urg 
#  1  8s chore Do the dishes    5.8
#  2  5s chore Wash the laundry 5.8
```

## gds

Same as `chore`, but implicit tag is `+gds`and no special urgency

## organon

Same as `chore`, but implicit tag is `+organon`and no special urgency

## switch-context

For now, just cycle through context and do set them even if no related tasks.

## todo

```bash
todo Do the dishes
# Created task 1.
task
# ID Age Tag  Description   Urg 
#  1  1s todo Do the dishes 0.8
```
