resource "google_project_service" "artifactregistry" {
  project = "coviscan-339716"
  service = "artifactregistry.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
  disable_on_destroy = true
}

resource "google_project_service" "run" {
  project = "coviscan-339716"
  service = "run.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
  
  disable_dependent_services = true
  disable_on_destroy = true
}

module my_cloud_run_service {
  source = "garbetjie/cloud-run/google"
  version = "~> 2"
  
  # Required parameters
  name = "my-cloud-run-service"
  image = "us-docker.pkg.dev/cloudrun/container/hello"
  location = "us-central1"
  
  # Optional parameters
  allow_public_access = true
  args = []
  cloudsql_connections = []
  concurrency = 80
  cpu_throttling = true
  cpus = 1
  entrypoint = []
  env = [{ key = "ENV_VAR_KEY", value = "ENV_VAR_VALUE" }]
  ingress = "all"
  labels = {}
  map_domains = []
  max_instances = 1
  memory = 256
  min_instances = 0
  port = 8080
  project = "coviscan-339716"
  depends_on = [
    google_project_service.run,
    google_project_service.artifactregistry
  ]
}