package test

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/containerregistry/mgmt/2019-05-01/containerregistry"
	"github.com/Azure/azure-sdk-for-go/services/keyvault/mgmt/2018-02-14/keyvault"
	"github.com/Azure/go-autorest/autorest"
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

	authorizer, err := auth.NewAuthorizerFromEnvironment()
	if err != nil {
		t.Fatalf("Cannot get an Azure SDK Authorizer: %v", err)
	}

	resourceGroupName := "tf-ref-common-rg"
	keyVaultName := "tf-ref-common-kv"
	acrName := "tfrefcommonacr"

	// check the keyvault is deployed
	err = testKeyVault(authorizer, resourceGroupName, keyVaultName)
	if err != nil {
		t.Fatalf("KeyVault test has failed: %e", err)
	}

	// check the container registry is deployed
	err = testAzureContainerRegistry(authorizer, resourceGroupName, acrName)
	if err != nil {
		t.Fatalf("Azure Container Registry test has failed: %e", err)
	}
}

func testKeyVault(authorizer autorest.Authorizer, resourceGroupName string, vaultName string) error {
	AzureSubscriptionID := os.Getenv("AZURE_SUBSCRIPTION_ID")
	kvClient := keyvault.NewVaultsClient(AzureSubscriptionID)
	kvClient.Authorizer = authorizer

	_, err := kvClient.Get(context.Background(), resourceGroupName, vaultName)
	if err != nil {
		return fmt.Errorf("Cannot retrieve Azure Keyvault with name %s in resource group %s: %v", vaultName, resourceGroupName, err)
	}

	return nil
}

func testAzureContainerRegistry(authorizer autorest.Authorizer, resourceGroupName string, acrName string) error {
	AzureSubscriptionID := os.Getenv("AZURE_SUBSCRIPTION_ID")
	acrClient := containerregistry.NewRegistriesClient(AzureSubscriptionID)
	acrClient.Authorizer = authorizer

	_, err := acrClient.Get(context.Background(), resourceGroupName, acrName)
	if err != nil {
		return fmt.Errorf("Cannot retrieve Azure Container Registry with name %s in resource group %s: %v", acrName, resourceGroupName, err)
	}

	return nil
}
