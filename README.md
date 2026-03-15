# Ubuntu / WSL Bootstrap Kit

Ubuntu・WSL・Dev Container・cloud-init・Ansible を役割分担して組み合わせ、
**新規参加者が最短で開発に着手できる**ことを目的にした、
開発環境自動構築テンプレートです。

このリポジトリは、単発スクリプト集ではなく、
- 再現性（同じ状態を何度でも作れる）
- オンボーディング速度（初日から迷わない）
- Git 管理（変更履歴で追える）
- 保守性（責務分離で育てられる）
を重視して設計します。

## Why

多くのチームで「環境構築の属人化」が開発開始の遅延要因になります。
本テンプレートは、以下の観点でその課題を減らすことを狙います。

- **ローカル**: WSL2 上の Ubuntu を前提に、最小手順で作業可能状態へ
- **開発コンテナ**: VS Code Dev Container で共通実行環境を固定
- **VM 初回起動**: cloud-init で初期ユーザー・鍵・基本パッケージを自動化
- **継続構成管理**: Ansible で「初回だけで終わらない」状態維持を実現

採用ポートフォリオとしては、
「運用目線で開発基盤を設計し、段階的に自動化できる」ことを伝える構成です。

## Scope

### 対象
- Ubuntu 24.04 系
- WSL2 上の Ubuntu
- VS Code Dev Containers
- Proxmox 等で作成する Ubuntu VM
- 個人〜小規模チーム

### 非対象（この初期版で扱わないもの）
- 大規模マルチテナント運用
- 本番インフラの完全自動化（Terraform/Kubernetes など）
- 機密情報の自動配布（Secrets Manager 連携）

## Architecture

責務を重ねすぎないために、次の分離を採用します。

1. **Local Bootstrap (`scripts/bootstrap.sh`)**
   - 開発者端末（WSL 含む）向けの初期セットアップ
   - 最小限の依存導入と開発開始準備

2. **Dev Container (`.devcontainer/`)**
   - Node.js / Python が使える再現可能な開発環境
   - ホスト差分を吸収してチーム共通化

3. **VM First Boot (`cloud-init/user-data.yml`)**
   - VM 起動時のユーザー作成、sudo、SSH 鍵導線、基本パッケージ導入
   - 「最初の 1 回」を確実に自動化

4. **Continuous Configuration (`ansible/`)**
   - cloud-init 後の継続適用
   - 変更の宣言的管理と差分反映

### 予定ディレクトリツリー（初期設計）

```text
.
├── README.md
├── Makefile
├── .env.example
├── packages/
│   └── apt.txt
├── scripts/
│   └── bootstrap.sh
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── postCreate.sh
├── cloud-init/
│   └── user-data.yml
├── ansible/
│   ├── site.yml
│   └── roles/
│       └── common/
│           └── tasks/
│               └── main.yml
├── docs/
│   ├── architecture.md
│   └── onboarding.md
└── .github/
    └── workflows/
        └── ci.yml
```

> 今回のステップでは、まずこのツリー方針と README を確定し、
> 次ステップで各ファイルを実装します。

## Quick Start

> 本ステップでは設計先行のため、実装コマンドは次回追加予定です。

将来的な利用イメージ:

```bash
git clone <this-repo>
cd ubuntu-wsl-bootstrap-kit
make setup
make verify
```

## Before / After

### Before
- 新規参加者ごとに環境構築手順がバラバラ
- 「誰かのメモ」に依存し、再現性が低い
- VM 初期化と運用中変更が混在し、責務が曖昧

### After
- README 起点で環境構築の導線が一本化
- Dev Container により実行環境差異を最小化
- cloud-init（初回）と Ansible（継続）を分離し、保守しやすい

## Tech Stack

- Ubuntu 24.04 / WSL2
- Bash
- Make
- VS Code Dev Containers
- cloud-init
- Ansible
- GitHub Actions（shellcheck / ansible-lint / markdownlint）

## Operational Considerations

- **Secrets をコミットしない**: `.env.example` のみを管理
- **冪等性**: スクリプトと Playbook は再実行を前提
- **破壊的操作を避ける**: 初期版は最小安全セット
- **責務分離**: ローカル / VM 初回 / 継続管理を混在させない
- **段階導入**: 最初は最小パッケージ、必要時に拡張

## Demo

公開用デモでは、次を短時間で再現できることを示します。

1. WSL Ubuntu で `make setup`
2. Dev Container 起動で Node/Python 利用確認
3. cloud-init で VM 初回構成を反映
4. Ansible 再適用で差分管理を実演

## Lessons Learned

このテンプレートで伝えたいのは、
「ツールを増やすこと」よりも「責務を整理して運用可能な形にすること」です。

- 初回構築と継続運用を分離すると、障害点の切り分けが容易
- Git 管理できる構成定義は、引き継ぎコストを下げる
- 開発者体験（DevEx）は、速度だけでなく再現性と保守性の掛け算で決まる
