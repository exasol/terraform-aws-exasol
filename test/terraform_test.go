package test

import (
	"testing"

	"github.com/grantstreetgroup/go-exasol-client"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/sethvargo/go-password/password"
)

// run with go test --timeout 2h
func TestExasolTerraformModule(t *testing.T) {
	t.Parallel()
	sysPassword := getRandomPassword()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./simple_exasol_setup/",

		Vars: map[string]interface{}{
			"exasol_admin_password": getRandomPassword(),
			"exasol_sys_password":   sysPassword,
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	datanodeIp := terraform.Output(t, terraformOptions, "datanode_ip")
	assertCanConnect(t, datanodeIp, sysPassword)
}

func getRandomPassword() string {
	res, err := password.Generate(20, 5, 0, false, false)
	if err != nil {
		panic(err)
	}
	return res
}

func assertCanConnect(t *testing.T, ip string, sysPassword string) {
	conf := exasol.ConnConf{
		Host:     ip,
		Port:     8563,
		Username: "sys",
		Password: sysPassword,
	}
	conn, err := exasol.Connect(conf)
	if err != nil {
		t.Error("Failed to connect to the exasol database: " + err.Error())
	}
	defer conn.Disconnect()

	_, err = conn.Execute("SELECT * FROM DUAL")
	if err != nil {
		t.Error("Failed to run query on the exasol database: " + err.Error())
	}
}
