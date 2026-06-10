#!/bin/bash
# Mock terraform binary that outputs "no changes" plan output
# Usage: mock-terraform-no-changes.sh show -no-color <planfile>
echo "No changes. Your infrastructure matches the configuration."
echo ""
echo "Terraform has compared your real infrastructure against your configuration"
echo "and found no differences, so no changes are needed."
