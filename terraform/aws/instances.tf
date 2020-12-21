resource "aws_instance" "web" {
  count = var.web_count

  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "ubuntu"
  }

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.auth.id
  iam_instance_profile = aws_iam_instance_profile.monitoring.name

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.http.id,
  ]

  subnet_id = element(aws_subnet.public.*.id, count.index)

  volume_tags = {
    Name        = "dn-${terraform.workspace}-web-${count.index + 1}"
    Hostname    = "web-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  tags = {
    Name        = "dn-${terraform.workspace}-web-${count.index + 1}"
    Hostname    = "web-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  lifecycle {
    ignore_changes = [ami]
  }

}

# xazabd wallet nodes (for faucet and masternode collaterals)
resource "aws_instance" "xazabd_wallet" {
  count = var.wallet_count

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.auth.id
  iam_instance_profile = aws_iam_instance_profile.monitoring.name

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.xazabd_private.id,
  ]

  subnet_id = element(aws_subnet.public.*.id, count.index)

  volume_tags = {
    Name        = "dn-${terraform.workspace}-xazabd-wallet-${count.index + 1}"
    Hostname    = "xazabd-wallet-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  tags = {
    Name        = "dn-${terraform.workspace}-xazabd-wallet-${count.index + 1}"
    Hostname    = "xazabd-wallet-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  lifecycle {
    ignore_changes = [ami]
  }

}

# xazabd full nodes
resource "aws_instance" "xazabd_full_node" {
  count = var.node_count

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.auth.id
  iam_instance_profile = aws_iam_instance_profile.monitoring.name

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.xazabd_public.id,
  ]

  subnet_id = element(aws_subnet.public.*.id, count.index)

  volume_tags = {
    Name        = "dn-${terraform.workspace}-node-${count.index + 1}"
    Hostname    = "node-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  tags = {
    Name        = "dn-${terraform.workspace}-node-${count.index + 1}"
    Hostname    = "node-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  lifecycle {
    ignore_changes = [ami]
  }

}

# cpu miners (not running a node)
resource "aws_instance" "miner" {
  count = var.miner_count

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.small"
  key_name             = aws_key_pair.auth.id
  iam_instance_profile = aws_iam_instance_profile.monitoring.name

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.xazabd_private.id,
  ]

  subnet_id = element(aws_subnet.public.*.id, count.index)

  volume_tags = {
    Name        = "dn-${terraform.workspace}-miner-${count.index + 1}"
    Hostname    = "miner-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  tags = {
    Name        = "dn-${terraform.workspace}-miner-${count.index + 1}"
    Hostname    = "miner-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  lifecycle {
    ignore_changes = [ami]
  }

}

# masternodes
resource "aws_instance" "masternode" {
  count = var.masternode_count

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.medium"
  key_name             = aws_key_pair.auth.id
  iam_instance_profile = aws_iam_instance_profile.monitoring.name

  vpc_security_group_ids = [
    aws_security_group.default.id,
    aws_security_group.xazabd_public.id,
    aws_security_group.masternode.id,
  ]

  subnet_id = element(aws_subnet.public.*.id, count.index)

  root_block_device {
    volume_size = "30"
  }

  volume_tags = {
    Name        = "dn-${terraform.workspace}-masternode-${count.index + 1}"
    Hostname    = "masternode-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  tags = {
    Name        = "dn-${terraform.workspace}-masternode-${count.index + 1}"
    Hostname    = "masternode-${count.index + 1}"
    XazabNetwork = terraform.workspace
  }

  lifecycle {
    ignore_changes = [ami]
  }

}

resource "aws_instance" "vpn" {
  count = var.vpn_enabled ? 1 : 0

  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.nano"
  key_name             = aws_key_pair.auth.id
  iam_instance_profile = aws_iam_instance_profile.monitoring.name

  subnet_id = element(aws_subnet.public.*.id, count.index)

  vpc_security_group_ids = [
    aws_security_group.vpn[0].id,
  ]

  volume_tags = {
    Name        = "dh-${terraform.workspace}-vpn"
    Hostname    = "vpn"
    XazabNetwork = terraform.workspace
  }

  tags = {
    Name        = "dh-${terraform.workspace}-vpn"
    Hostname    = "vpn"
    XazabNetwork = terraform.workspace
  }

  lifecycle {
    ignore_changes = [ami]
  }

}

