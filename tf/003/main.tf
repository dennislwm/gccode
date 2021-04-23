provider "google" {
  credentials = file(var.strSshKey)
  project = var.strProject
  region  = var.strRegion
  zone    = var.strZone
}
terraform {
  backend "gcs" {
    bucket      = "bu-gccode-001"
    prefix      = "tf"
    credentials = "../../config/sa-gccode-key.json"
  }
}

resource "google_compute_network" "objVpcNetwork" {
  name  = "vn-gccode-003"
}
resource "google_compute_instance" "objComputeInstance" {
  name                    = "co-gccode-003"
  machine_type            = var.strMachineType
  tags                    = ["tg-public"]
  zone                    = var.strZone
  boot_disk {
    initialize_params {
      image = var.strImage
    }
  }
  network_interface {
    network = google_compute_network.objVpcNetwork.name
    access_config {
      nat_ip  = google_compute_address.objComputeIp.address
    }
  }
}
resource "google_compute_address" "objComputeIp" {
  name = "ip-gccode-003"
}
resource "google_compute_firewall" "objComputeFirewall" {
  name    = "fw-gccode-003-public"
  network = google_compute_network.objVpcNetwork.name
  allow {
    protocol  = "icmp"
  }
  allow {
    protocol  = "tcp"
    ports     = ["22", "80", "8080", "1000-2000"]
  }
  target_tags   = ["tg-public"]
  source_ranges = ["0.0.0.0/0"]
}