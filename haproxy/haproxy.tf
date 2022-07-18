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
resource "google_compute_firewall" "default" {
name    = "main-firewall"
network = google_compute_network.default.name

allow {
  protocol = "icmp"
}

allow {
  protocol = "tcp"
  ports    = ["80", "8080", "1000-2000"]
}

source_tags = ["web"]
}

resource "google_compute_network" "default" {
name = "main-network"
}

