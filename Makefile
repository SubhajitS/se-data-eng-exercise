init:
	cd infra/; terraform init;
plan:
	@echo "Init and plan Terraform deployment"
	cd infra/; terraform init -reconfigure; terraform plan;
apply: plan
	@echo "Apply Terraform deployment"
	cd infra/; terraform apply --auto-approve;
destroy:
	@echo "About to tear down the infra"
	cd infra/; terraform destroy --auto-approve;