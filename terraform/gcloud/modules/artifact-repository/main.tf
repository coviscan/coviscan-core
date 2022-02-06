resource "google_project_service" "cloudresourcemanager" {
  project = "coviscan-339716"
  service = "cloudresourcemanager.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
  disable_on_destroy = true
}

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

resource "google_artifact_registry_repository" "dcc-validation-decorator" {
  provider = google-beta

  location = "us-central1"
  repository_id = "dcc-validation-decorator"
  description = "Docker repository for dcc-validation-decorator"
  format = "DOCKER"
}