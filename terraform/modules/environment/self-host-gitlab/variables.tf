# common parameter
variable "tags" {
  description = "リソース群に付与する共通タグ"
  type        = map(string)
}

variable "pj" {
  description = "リソース群に付与する接頭語"
  type        = string
}

variable "vpc_id" {
  description = "リソース群が属するVPCのID"
  type        = string
}

# module parameter
variable "ec2_instance_type" {
  description = "GitLabのインスタンスタイプ"
  type        = string
}

variable "ec2_ami" {
  description = "GitLabのAMI。とくに指定ない場合マーケットプレイスの最新を使用"
  type        = string
  default     = null
}

variable "ec2_subnet_id" {
  description = "GitLabを配置するパブリックサブネットのID"
  type        = string
}

variable "ec2_root_block_volume_size" {
  description = "GitLabのルートデバイスの容量(GB)"
  type        = string
}

variable "ec2_key_name" {
  description = "GitLabインスタンスにsshログインするためのキーペア名"
  type        = string
}

variable "sg_ingresses" {
  description = "GitLabインスタンスに付与するSGのインバウンド"
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
}

variable "cloudwatch_enable_schedule" {
  description = "GitLabインスタンスを自動起動/停止するか"
  type        = bool
  default     = false
}

variable "cloudwatch_start_schedule" {
  description = "GitLabインスタンスを自動起動する時間。時間の指定はUTCのため注意"
  type        = string
  default     = "cron(0 0 ? * MON-FRI *)"
}

variable "cloudwatch_stop_schedule" {
  description = "GitLabインスタンスを自動停止する時間。時間の指定はUTCのため注意"
  type        = string
  default     = "cron(0 10 ? * MON-FRI *)"
}

variable "dlm_enable_snapshot" {
  description = "GitLabインスタンスのEBSを自動スナップショットするか"
  type        = bool
  default     = false
}

variable "dlm_snaphost_time" {
  description = "GitLabインスタンスのEBSをスナップショット取る時間"
  type        = string
  default     = "15:00"
}

variable "dlm_snaphost_count" {
  description = "GitLabインスタンスのEBSをスナップショット取る世代数"
  type        = number
  default     = 1
}