# レポジトリの概要

本レポジトリは GitLab CICD + AWS CodePipeline/Deploy を使用したECSのCICDパイプラインの仕組みと構築方法を解説したものです。

AWSの構築はTerraformを使用します。

パイプラインの動作を確認するためのアプリケーションとECS設定のサンプルレポジトリも用意しています。

本レポジトリで作成する環境のイメージは次の通りです。

**AWS環境図**

![AWS環境図](./documents/images/aws.svg)

**CICDフロー図**

![CICDフロー図](./documents/images/cicd.svg)

# バージョン

本レポジトリのモジュール群は以下のバージョンを前提としてます。（構築時のバージョンも記載します。）

terraform 0.13.2 以上　（構築時 0.13.3）  
aws providor 3.5.0以上　

# ドキュメント

モジュールや使い方などのドキュメントは以下になります。

- [モジュール説明](./documents/module.md)
- [CICDフロー説明](./documents/cicd.md)
- [使い方](./documents/howtouse.md)

# ディレクトリ説明

利用者が意識する主要なディレクトリ・ファイルについて説明します。

```
.
├── documents                 # 本レポジトリのドキュメント一式を格納しています。
│   ├── cicd.md               # CICDの流れを説明したドキュメントです。
│   ├── howtouse.md           # 本レポジトリのモジュールを使用して環境を構築する方法を解説したドキュメントです。
│   └── module.md             # 用意しているterraformモジュールを説明したドキュメントです。
├── sample-repos              # GitLab CICDのサンプルです。
│   ├── app                   # アプリケーションのサンプルです。
│   └── ecs                   # ECS設定のサンプルです。
└── terraform                 # terraformのコード一式を格納しています。
    ├── main-template         # PJの環境(dev/stg等)ごとに使用するテンプレートです。
    │   ├── environment       # 環境構築に使用するterraformコード一式です。
    │   └── service-template  # ECSサービスごとに使用するテンプレートです。
    └── modules               # モジュールを実装したコードを格納しています。
```