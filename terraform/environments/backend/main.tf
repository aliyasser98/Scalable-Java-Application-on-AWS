provider "aws" {
    region = var.region
}
module "backend" {
    source = "../../modules/backend"
    environment = var.environment
}