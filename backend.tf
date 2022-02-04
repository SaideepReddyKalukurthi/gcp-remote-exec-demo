terraform {
    backend "gcs" {
        bucket = "learning-025"
        prefix = "state-files"      
    }
  
}