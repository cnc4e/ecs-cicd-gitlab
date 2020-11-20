# common parameter
variable "pj" {
  description = "リソース群に付与する名前の接頭語。プロジェクト名。"
  type        = string
}

variable "app" {
  description = "リソース群に付与する名前の接頭語。アプリケーション名。"
  type        = string
}

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

variable "task_execution_role_arn" {
  description = "タスクを実行するIAMロールのARN"
  type        = string
}

## ecs-service.tf
variable "service_name" {
  description = "サービスの名前"
  type        = string
}

variable "service_cluster_arn" {
  description = "サービスをデプロイするECSクラスタのARN"
  type        = string
}

variable "service_desired_count" {
  description = "サービスで動かすタスクの数"
  type        = number
}

variable "service_allow_inbound_sgs" {
  description = "サービスのSGに設定するインバウンドアクセスを許可するSGのリスト"
  type        = list(string)
}

variable "service_subnets" {
  description = "サービスのタスクをデプロイするサブネットIDのリスト"
  type        = list(string)
}

variable "service_container_name" {
  description = "サービスに紐づくロードバランサに接続するタスク内のコンテナ名"
  type        = string
}

variable "service_container_port" {
  description = "サービスに紐づくロードバランサに接続するタスク内のコンテナの待受ポート"
  type        = number
}

variable "service_sg_id" {
  description = "サービスに付与するセキュリティグループ"
  type        = string
}

## elb-listener-target.tf
variable "elb_arn" {
  description = "サービスに紐付けるELBのARN"
  type        = string
}

variable "elb_prod_traffic_port" {
  description = "ロードバランサの本番待受ポート"
  type        = number
}

variable "elb_prod_traffic_protocol" {
  description = "ロードバランサの本番待受プロトコル"
  type        = string
}

variable "elb_backend_port" {
  description = "ロードバランサが流す宛先のポート"
  type        = number
}

variable "elb_backend_protocol" {
  description = "ロードバランサが流す宛先のプロトコル"
  type        = string
}

variable "elb_backend_health_check_path" {
  description = "ロードバランサのヘルスチェックを行う宛先パス"
  type        = string
}

## cloudwatch-logs.tf
variable "clowdwatch_log_groups" {
  description = "cloudwatch logs に作成する各コンテナのログストリーム"
  type        = list(string)
}
