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