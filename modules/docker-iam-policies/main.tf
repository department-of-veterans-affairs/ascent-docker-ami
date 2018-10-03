# ---------------------------------------------------------------------------------------------------------------------
# ATTACH AN IAM POLICY THAT ALLOWS THE DOCKER SERVER TO AUTOMATICALLY DISCOVER OTHER CLUSTER NODES
# ---------------------------------------------------------------------------------------------------------------------

# Need to be able to describe instances in order to auto join cluster, need additional IAM policies so that we can
#     authenticate to vault via the AWS method.
data "aws_iam_policy_document" "docker_policy" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "iam:GetInstanceProfile",
      "iam:GetUser",
      "iam:GetRole",
      "sts:GetFederationToken",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "docker_policy" {
  name_prefix = "discover-nodes-"
  policy      = "${data.aws_iam_policy_document.docker_policy.json}"
  role        = "${var.iam_role_id}"
}
