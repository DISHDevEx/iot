
output "log_group_arn" {
  value = data.aws_cloudwatch_log_group.sfn_data.arn
}

output "step_function_arn" {
  value = aws_sfn_state_machine.step_function.arn
}