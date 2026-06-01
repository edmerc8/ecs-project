module "s3_backend" {
  source = "../backend"

  bucket_name = "edmerc8-ecs-state-bucket"
}

module "ecr_repo" {
  source = "../base_infrastructure/ecr"
}