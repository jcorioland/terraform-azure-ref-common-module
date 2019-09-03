package test

import (
	"context"
	"fmt"
	"log"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2018-02-14/keyvault"
	"github.com/Azure/go-autorest/autorest/azure/auth"
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

	resourceGroupName := "tf-ref-common-rg"
	keyVaultName := "tf-ref-common-kv"

	// check the keyvault is deployed
	err := testKeyVault(resourceGroupName, keyVaultName)
	if err != nil {
		t.Fatalf("KeyVault test has failed: %e", err)
	}
}

func testKeyVault(resourceGroupName string, vaultName string) error {
	AzureSubscriptionID := os.Getenv("AZURE_SUBSCRIPTION_ID")
	log.Printf("############ SUBSCRIPTION ID = %s", AzureSubscriptionID)

	kvClient := keyvault.NewVaultsClient(AzureSubscriptionID)
	authorizer, err := auth.NewAuthorizerFromEnvironment()
	if err == nil {
		kvClient.Authorizer = authorizer
	} else {
		return fmt.Errorf("Cannot get an Azure SDK Authorizer: %v", err)
	}

	_, err = kvClient.Get(context.Background(), resourceGroupName, vaultName)
	if err != nil {
		return fmt.Errorf("Cannot retrieve Azure Keyvault with name %s in resource group %s: %v", vaultName, resourceGroupName, err)
	}

	return nil
}
