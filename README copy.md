# opsfleet-task

- modules
    - vpc and networking
    - eks
    - karpenter


terraform init --backend-config=environment/dev/backend.conf
terraform plan --var-file=environment/dev/dev.tfvars