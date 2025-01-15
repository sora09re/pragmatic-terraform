resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true # DNSサーバーによる名前解決の有効化
  enable_dns_hostnames = true # リソースへのパブリックDNSホスト名の自動割り当てを有効化

  tags = {
    Name = "s-aoki-example"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}
