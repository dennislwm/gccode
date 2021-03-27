provider "google" {
  credentials = file("../../config/sa-gccode-key.json")

  project = "gccode"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "objVpcNetwork" {
  name = "vn-gccode"
}

terraform {
  backend "gcs" {
    bucket  = "bu-gccode-01"
    prefix  = "tf"
    credentials = "../../config/sa-gccode-key.json"
  }
}