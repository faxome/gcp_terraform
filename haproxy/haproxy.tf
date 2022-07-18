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
      image = "ubuntu-haproxy"
    }
  }
network_interface {
  network = "default"
  access_config {}
}
}
