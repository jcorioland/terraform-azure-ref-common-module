package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestCommonModule(t *testing.T) {
	t.Parallel()

	terraformFixtureOptions := &terraform.Options{
		TerraformDir: "./fixture",
		VarFiles:     []string{"testing.tfvars"},
	}

	defer terraform.Destroy(t, terraformFixtureOptions)
	terraform.InitAndApply(t, terraformFixtureOptions)

	// todo: test
}
