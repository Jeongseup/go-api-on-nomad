# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: BUSL-1.1

# Full configuration options can be found at https://www.consul.io/docs/agent/config

data_dir = "/opt/consul"


client_addr = "0.0.0.0"  # ← 추가 필요 (UI 외부 노출 허용)
ui_config{
  enabled = true
}

server = true
bootstrap_expect = 1
bind_addr = "192.168.0.90"
retry_join = ["192.168.0.90"]

dns_config {
  enable_truncate = true
  only_passing    = true
}
