terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tf-state-prod-bucket" 
    region     = "ru-central1"
    key        = "terraform/state/terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}