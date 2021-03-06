provider "google" {
  credentials = file("../../config/sa-gccode-key.json")

  project = "gccode-002"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "objVpcNetwork" {
  name = "vn-gccode-002"
}

terraform {
  backend "gcs" {
    bucket  = "bu-gccode-002"
    prefix  = "tf"
    credentials = "../../config/sa-gccode-key.json"
  }
}

resource "google_compute_instance" "objComputeInstance" {
  name         = "co-gccode-002"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.objVpcNetwork.name
    access_config {
      nat_ip = google_compute_address.objComputeIp.address
    }
  }
}
resource "google_compute_address" "objComputeIp" {
  name = "ip-gccode-002"
}
