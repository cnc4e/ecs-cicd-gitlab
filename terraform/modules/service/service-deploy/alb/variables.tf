# common parameter
variable "app_full" {
  description = "リソース群に付与する名前の接頭語。プロジェクト名-アプリケーション名。"
  type        = string
}

variable "vpc_id" {
  description = "リソース群が属するVPCのID"
  type        = string
}

variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
}

# module parameter
variable "lb_subnet_ids" {
  description = "LBが接続する異なるAZのサブネットID"
  type        = list(string)
}

variable "lb_service_sg_id" {
  description = "ECS ServiceのSG ID"
  type        = string
}