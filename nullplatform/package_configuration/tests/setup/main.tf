# Run first by the tests: the stand-in for `np` starts with an empty log, so
# what a run finds there was written by this run of the tests.
resource "terraform_data" "empty_log" {
  provisioner "local-exec" {
    command = "rm -f \"${path.module}/../.np-stub.log\""
  }
}
