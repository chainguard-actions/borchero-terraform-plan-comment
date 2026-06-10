#!/bin/bash
# Mock terraform binary that outputs a plan with changes
# Usage: mock-terraform-with-changes.sh show -no-color <planfile>

cat <<'EOF'
Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.example will be created
  + resource "aws_s3_bucket" "example" {
      + bucket = "my-example-bucket"
      + id     = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
EOF
