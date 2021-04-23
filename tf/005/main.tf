provider "google" {
  credentials = file(var.strSshKey)
  project = var.strProject
  region  = var.strRegion
  zone    = var.strZone
}
terraform {
  backend "gcs" {
    bucket      = "bu-gccode-005"
    prefix      = "tf"
    credentials = "../../config/sa-gccode-key.json"
  }
}
resource "google_compute_network" "objVpcNetwork" {
  name  = "vn-gccode-005"
}

resource "google_compute_autoscaler" "objComputeAutoscaler" {
  name    = "ca-gccode-005"
  project = var.strProject
  zone    = var.strZone
  target  = google_compute_instance_group_manager.objComputeGroupManager.self_link

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
resource "google_compute_instance_template" "objComputeTemplate" {
  name            = "ct-gccode-005"
  machine_type    = var.strMachineType
  can_ip_forward  = false
  project         = var.strProject
  tags            = ["foo", "bar", "allow-lb-service"]

  disk {
    source_image  = data.google_compute_image.objComputeImage.self_link
  }

  network_interface {
    network       = google_compute_network.objVpcNetwork.name
  }
  
  metadata = {
    foo           = "bar"
  }

  service_account {
    scopes        = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
module "lb" {
  source  = "GoogleCloudPlatform/lb/google"
  version = "2.2.0"
  region       = var.strRegion
  name         = "lb-gccode-005"
  service_port = 80
  target_tags  = ["cp-gccode-005"]
  network      = google_compute_network.objVpcNetwork.name
}

resource "google_compute_target_pool" "objComputeTargetPool" {
  name    = "cp-gccode-005"
  project = var.strProject
  region  = var.strRegion
}
resource "google_compute_instance_group_manager" "objComputeGroupManager" {
  name    = "cg-gccode-005"
  zone    = var.strZone
  project = var.strProject
  version {
    instance_template = google_compute_instance_template.objComputeTemplate.self_link
    name              = "primary"
  }

  target_pools        = [google_compute_target_pool.objComputeTargetPool.self_link]
  base_instance_name  = "ci-gccode-005"
}

data "google_compute_image" "objComputeImage" {
  family  = "centos-7"
  project = "centos-cloud"
}