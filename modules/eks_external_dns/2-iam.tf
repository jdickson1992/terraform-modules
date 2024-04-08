# Policy Document
data "aws_iam_policy_document" "external_dns" { #tfsec:ignore:aws-iam-no-policy-wildcards
  statement {
    sid = "ChangeResourceRecordSets"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/${var.zone_id}"]

    effect = "Allow"
  }

  statement {
    sid = "ListResourceRecordSets"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource",
    ]

    resources = [
      "*",
    ]

    effect = "Allow"
  }
}

# Policy
resource "aws_iam_policy" "external_dns_pod_policy" {
  name = "${var.cluster_name}-external-dns-pod-policy"
  path        = "/"
  description = "Policy for external-dns service"
  policy = data.aws_iam_policy_document.external_dns[0].json
}

# Role
data "aws_iam_policy_document" "external_dns_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_openid_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_openid_provider_url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:external-dns",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "external_dns_role" {
  name = "${var.cluster_name}-external-dns"
   assume_role_policy = data.aws_iam_policy_document.external_dns_assume[0].json
}

resource "aws_iam_role_policy_attachment" "external_dns_role_attachment" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = aws_iam_policy.external_dns_pod_policy.arn
}
