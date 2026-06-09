#!/bin/sh
# Mock terraform binary for testing
# Simulates: terraform show -no-color <planfile>
echo "No changes. Your infrastructure matches the configuration."
echo ""
echo "Terraform has compared your real infrastructure against your configuration"
echo "and found no differences, so no changes are needed."
