# common parameter
variable "pj" {
  description = "リソース群に付与する接頭語"
  type        = string
}

variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
}

# module parameter
variable "cluster_name" {
  description = "ECSクラスタのクラスタ名"
  type        = string
}