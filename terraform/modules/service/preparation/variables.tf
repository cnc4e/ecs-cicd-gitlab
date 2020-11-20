# common parameter
variable "vpc_id" {
  description = "リソース群が属するVPCのID"
  type        = string
}

variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
}

# module parameter

# ecr.tf
variable "ecr_repositories" {
  description = "作成するECRリポジトリ名のリスト"
  type        = list(string)
}

# s3.tf
variable "s3_service_settings_bucket_name" {
  description = "appspec.yamlをzipにしたsettings.zipを配置するバケット名"
  type        = string
}

# sg.tf
variable "sg_name" {
  description = "ECS Serviceに付与するSGの名前"
  type        = string
}
