output "security_group_id" {
  value = "${aws_security_group.lc_security_group.id}"
}

output "docker_worker_asg_name" {
  value = "${aws_autoscaling_group.autoscaling_group_worker.name}"
}

output "instance_role_arn" {
  value = "${aws_iam_role.instance_role.arn}"
}
