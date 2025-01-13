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

# パブリックネットワーク
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true # パブリックIPアドレスの自動割り当てを有効化
  availability_zone       = "ap-northeast-1a"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
