output "glue_job_id" {
  description = "Glue job name."
  value       = aws_glue_job.IOT_glue_job[*].id
}

output "glue_job_arn" {
  description = "ARN of Glue Job."
  value       = aws_glue_job.IOT_glue_job[*].arn
}

