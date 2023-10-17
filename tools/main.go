package main

import (
	"context"
	"log"
	"os"

	"github.com/hashicorp/go-tfe"
)

var (
	workspaceName string = os.Getenv("INPUT_WORKSPACE_NAME")
	token         string = os.Getenv("TF_API_TOKEN")
	projectId     string = os.Getenv("INPUT_PROJECT_ID")
)

const (
	// workspaceName string = "test-cli-workspace"
	// token         string = ""
	// projectId     string = "prj-GLKfaFAUJMGv1YQ3"
	errMessage string = "invalid attribute\n\nName has already been taken"
)

func main() {

	config := &tfe.Config{
		Address:           "https://app.terraform.io",
		Token:             token,
		RetryServerErrors: true,
	}

	client, err := tfe.NewClient(config)
	if err != nil {
		log.Fatal(err)
	}

	ctx := context.Background()
	orgs, err := client.Organizations.List(ctx, nil)
	if err != nil {
		log.Fatal(err)
	}

	for _, org := range orgs.Items {
		proj, err := client.Projects.Read(ctx, projectId)
		if err != nil {
			log.Fatal(err)
		}
		opt := tfe.WorkspaceCreateOptions{
			Name:               tfe.String(workspaceName),
			SpeculativeEnabled: tfe.Bool(true),
			TerraformVersion:   tfe.String("1.6.0"),
			Project:            proj,
		}
		workspace, err := client.Workspaces.Create(ctx, org.Name, opt)
		if err != nil {
			if err.Error() == errMessage {
				workspace, err := client.Workspaces.Read(ctx, org.Name, workspaceName)
				if err != nil {
					log.Fatal(err)
				}

				if workspace.Project.ID == proj.ID {
					log.Println("Workspace exists\n\nIt is in the correct project.")
					os.Exit(0)
				} else {
					client.Workspaces.Update(ctx, org.Name, workspace.Name, tfe.WorkspaceUpdateOptions{
						Project: proj,
					})
					log.Println("Workspace exists\n\nIt is moved to the correct project now.")
					os.Exit(0)
				}
			} else {
				log.Fatal(err)
			}
		}
		log.Println(workspace.Name)
	}
}
