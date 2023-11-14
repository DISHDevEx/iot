output "cluster_arn" {
  description = "The ARN of the cluster"
  value       = try(aws_emr_cluster.this.arn, null)
}

output "cluster_id" {
  description = "The ID of the cluster"
  value       = try(aws_emr_cluster.this.id, null)
}

output "cluster_master_public_dns" {
  description = "The DNS name of the master node. If the cluster is on a private subnet, this is the private DNS name. On a public subnet, this is the public DNS name"
  value       = try(aws_emr_cluster.this.master_public_dns, null)
}
