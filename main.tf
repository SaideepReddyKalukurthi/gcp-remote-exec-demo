
provider "google" {
    project = var.project_name  
    region = var.region
}



resource "google_compute_firewall" "firewall" {
  project = var.project_name
  name    = "sai-firewall-externalssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }
  source_ranges = ["0.0.0.0/0"] 
  target_tags   = ["externalssh"]
}


resource "google_compute_instance" "dev" {
  project = var.project_name
  name         = "devserver" 
  machine_type = "f1-micro" 
  zone         = "us-central1-c" 
  tags         = ["http-server","https-server","externalssh"] 

 
  boot_disk { 
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

   network_interface {
    network = "default"

       access_config {

    }
  }

 
  metadata = {
    ssh-keys = "${var.user}:${var.publickeypath}"
  }

    depends_on = [ google_compute_firewall.firewall]
}

resource "null_resource" "as" {

   connection {
       host        = google_compute_instance.dev.network_interface.0.access_config[0].nat_ip
      type        = "ssh"
      user        = var.user
      private_key = file("${var.privatekeypath}")
    }

    provisioner "file" {
      source = "start-up.sh"
      destination = "/home/sai/deep.sh"
    }

    provisioner "remote-exec" {
     inline = [
        "pwd", "chmod +x deep.sh", "./deep.sh"
      ]
    }
    depends_on = [
      google_compute_instance.dev
    ]

}


