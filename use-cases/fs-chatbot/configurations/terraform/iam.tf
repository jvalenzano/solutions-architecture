# iam.tf

# Service Account for Cloud Functions
resource "google_service_account" "function_account" {
  account_id   = "data-integration"
  display_name = "Data Integration Service Account"
}

# IAM bindings for the service account
resource "google_project_iam_member" "function_invoker" {
  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${google_service_account.function_account.email}"
}

resource "google_project_iam_member" "redis_accessor" {
  project = var.project_id
  role    = "roles/redis.editor"
  member  = "serviceAccount:${google_service_account.function_account.email}"
}
