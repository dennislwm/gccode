provider "google" {
  credentials = file("../../config/sa-gccode-key.json")

  project = "gccode-001"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "objVpcNetwork" {
  name = "vn-gccode-001"
}

terraform {
  backend "gcs" {
    bucket  = "bu-gccode-001"
    prefix  = "tf"
    credentials = "../../config/sa-gccode-key.json"
  }
}