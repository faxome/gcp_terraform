provider "google" {
  credentials = file("/home/debabiichuk/key.json")
  project     = "cadepo"
  region      = "northamerica-northeast2"
  zone        = "northamerica-northeast2-a"
}

resource "google_compute_instance" "haproxy" {
  name = "haproxy"
  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20220712a"
    }
  }
network_interface {
  network = "default"
}
}
resource "google_compute_firewall" "default" {
  name    = "test-firewall"
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
  name = "test-network"
}