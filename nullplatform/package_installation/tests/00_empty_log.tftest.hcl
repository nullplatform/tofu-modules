# Test files run in name order, so this one runs first: the stand-in for `np`
# starts with an empty log, and what a later run finds there was written by
# this run of the tests. It is a file of its own because the overrides of the
# other one name resources this helper module does not have.
run "the_stand_in_starts_with_an_empty_log" {
  command = apply

  module {
    source = "./tests/setup"
  }
}
