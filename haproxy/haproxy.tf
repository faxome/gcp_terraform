provider "google" {
  credentials = file("/home/debabiichuk/key.json")
  project     = "cadepo"
  region      = "northamerica-northeast2"
  zone        = "northamerica-northeast2-a"
}
resource "google_compute_attached_disk" "default" {
  disk     = "haproxy-logs"
  instance = "haproxy"
}

resource "google_compute_instance" "haproxy" {
  name = "haproxy"
  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-haproxy"
    }
  }
network_interface {
  network = "default"
  access_config {}
}
  lifecycle {
  ignore_changes = [attached_disk]
}
}
