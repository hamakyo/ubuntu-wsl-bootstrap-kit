# Ubuntu / WSL Bootstrap Kit

Ubuntu / WSL / Dev Container / cloud-init / Ansible を役割分担して組み合わせ、
新規参加者が最短で開発を開始できるようにする開発環境自動構築テンプレートです。

## Why

このリポジトリは、単なる便利スクリプト集ではなく、次の価値を再現可能な形で提供することを目指します。

- 再現性: 同じ初期状態を何度でも作れる
- オンボーディング速度: 初日から迷わずセットアップできる
- Git 管理: 変更理由と履歴を追跡できる
- 保守性: ローカル・VM初回・継続構成管理を分離できる

## Scope

### 対象
- Ubuntu 24.04 系
- WSL2 上の Ubuntu
- VS Code Dev Containers
- Proxmox 等で作成する Ubuntu VM
- 個人〜小規模チーム

### 非対象
- 大規模マルチテナント環境
- 本番インフラの包括自動化（Terraform/Kubernetes 等）
- シークレットの自動配布機構（Vault/Secrets Manager 連携等）

## Architecture

責務を分離し、各レイヤーを独立して改善できる構成を採用しています。

1. Local Bootstrap (`scripts/bootstrap.sh`)
   - 開発者ローカル（WSL含む）の初期パッケージ導入
2. Dev Container (`.devcontainer/`)
   - Node.js / Python 利用可能な共通開発環境
3. VM First Boot (`cloud-init/user-data.yml`)
   - ユーザー作成、sudo 設定、SSH 鍵導線、初回セットアップ
4. Continuous Configuration (`ansible/`)
   - cloud-init 後の継続的な構成適用

## 実装状況

### 実装済み
- `scripts/bootstrap.sh`
- `packages/apt.txt`
- `.devcontainer/Dockerfile`
- `.devcontainer/devcontainer.json`
- `.devcontainer/postCreate.sh`
- `cloud-init/user-data.yml`
- `ansible/site.yml`
- `ansible/roles/common/tasks/main.yml`
- `Makefile`
- `.github/workflows/ci.yml`
- `README.md`

### 未実装（次に追加予定）
- `.env.example`
- `docs/architecture.md`
- `docs/onboarding.md`

## Quick Start

```bash
git clone <this-repo>
cd ubuntu-wsl-bootstrap-kit

make setup
make verify
make lint
```

Dev Container 利用時:

1. VS Code でリポジトリを開く
2. `Dev Containers: Reopen in Container` を実行
3. コンテナ作成後に `make verify`

## cloud-init の SSH_PUBLIC_KEY 取り扱い

`cloud-init/user-data.yml` の `ssh_authorized_keys` は `$SSH_PUBLIC_KEY` を前提にしたテンプレートです。
cloud-init は環境変数を自動展開しないため、適用前にレンダリングしてください。

```bash
export SSH_PUBLIC_KEY="$(cat ~/.ssh/id_ed25519.pub)"
envsubst < cloud-init/user-data.yml > /tmp/user-data.rendered.yml
# 生成した /tmp/user-data.rendered.yml を NoCloud/Proxmox 側の user-data に指定
```

## Before / After

### Before
- 環境構築手順が人ごとに異なる
- 初回セットアップが口頭/個人メモ依存
- VM 初期化と継続運用の責務が混在

### After
- `make setup` 起点で初期導線を統一
- Dev Container でホスト差異を抑制
- cloud-init（初回）と Ansible（継続）を分離

## Tech Stack

- Ubuntu 24.04 / WSL2
- Bash / Make
- VS Code Dev Containers
- cloud-init
- Ansible
- GitHub Actions（shellcheck / ansible-lint / markdownlint）

## Operational Considerations

- Secrets はリポジトリに含めない（実値はコミットしない）
- スクリプト/Playbook は再実行可能性（冪等性）を重視
- 破壊的操作を避け、最小パッケージから開始
- ローカル・VM初回・継続構成管理の責務を分離

## Demo

デモの最小シナリオ:

1. WSL Ubuntu で `make setup`
2. `make verify` で必須コマンド確認
3. Dev Container 起動後に Node/Python 利用確認
4. cloud-init + Ansible の適用責務分離を説明

## Lessons Learned

- 「便利さ」より先に「責務分離」を設計する方が長期運用しやすい
- 初回構築（cloud-init）と継続運用（Ansible）を分けると障害対応が容易
- DevEx は速度だけでなく再現性と保守性で評価される

## GitHub Repository Metadata Suggestions

### About (description) 候補
1. Ubuntu/WSL onboarding template with Dev Container, cloud-init, and Ansible for reproducible developer environments.
2. Platform/DevEx portfolio template: bootstrap local Ubuntu/WSL, provision VM first-boot, and apply continuous config as code.
3. Reproducible dev environment kit for small teams using Ubuntu, WSL2, Dev Containers, cloud-init, and Ansible.

### Topics 候補（10個）
- ubuntu
- wsl2
- devcontainer
- cloud-init
- ansible
- devex
- platform-engineering
- onboarding
- infrastructure-as-code
- bootstrap
