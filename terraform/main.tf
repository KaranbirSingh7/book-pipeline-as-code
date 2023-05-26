resource "aws_organizations_policy" "scp_example" {
  name        = var.scp_name
  description = var.scp_description
  type        = "SERVICE_CONTROL_POLICY"
  content     = var.scp_policy_content
}
