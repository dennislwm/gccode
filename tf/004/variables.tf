variable "strSshKey" {
  default = "../../config/sa-gccode-key.json"
}

variable "strProject" {
  default = "gccode"
}

variable "strRegion" {
  default = "us-central1" 
}

variable "strZone" {
  default = "us-central1-c"
}

variable "strMachineType" {
  default = "f1-micro"
}

variable "strImage" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "strCidr" {
  default = "10.0.0.0/16"
}