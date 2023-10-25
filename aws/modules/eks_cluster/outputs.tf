output "eks_cluster_arn" {
  description = "The ARN of the created EKS Cluster."
  value       = aws_eks_cluster.eks_cluster_template.arn
}