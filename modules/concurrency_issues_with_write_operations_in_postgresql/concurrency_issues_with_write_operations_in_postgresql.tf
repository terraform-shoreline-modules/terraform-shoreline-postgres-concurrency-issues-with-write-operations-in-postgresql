resource "shoreline_notebook" "concurrency_issues_with_write_operations_in_postgresql" {
  name       = "concurrency_issues_with_write_operations_in_postgresql"
  data       = file("${path.module}/data/concurrency_issues_with_write_operations_in_postgresql.json")
  depends_on = [shoreline_action.invoke_stats_check,shoreline_action.invoke_update_table]
}

resource "shoreline_file" "stats_check" {
  name             = "stats_check"
  input_file       = "${path.module}/data/stats_check.sh"
  md5              = filemd5("${path.module}/data/stats_check.sh")
  description      = "Multiple users or processes are attempting to write to the same database table simultaneously."
  destination_path = "/tmp/stats_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_table" {
  name             = "update_table"
  input_file       = "${path.module}/data/update_table.sh"
  md5              = filemd5("${path.module}/data/update_table.sh")
  description      = "Use PostgreSQL's built-in locking mechanisms, such as row-level locks or advisory locks, to prevent multiple processes from writing to the same data at the same time."
  destination_path = "/tmp/update_table.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_stats_check" {
  name        = "invoke_stats_check"
  description = "Multiple users or processes are attempting to write to the same database table simultaneously."
  command     = "`chmod +x /tmp/stats_check.sh && /tmp/stats_check.sh`"
  params      = ["DATABASE_NAME","TABLE_NAME"]
  file_deps   = ["stats_check"]
  enabled     = true
  depends_on  = [shoreline_file.stats_check]
}

resource "shoreline_action" "invoke_update_table" {
  name        = "invoke_update_table"
  description = "Use PostgreSQL's built-in locking mechanisms, such as row-level locks or advisory locks, to prevent multiple processes from writing to the same data at the same time."
  command     = "`chmod +x /tmp/update_table.sh && /tmp/update_table.sh`"
  params      = ["ID_VALUE","DATABASE_NAME","TABLE_NAME"]
  file_deps   = ["update_table"]
  enabled     = true
  depends_on  = [shoreline_file.update_table]
}

