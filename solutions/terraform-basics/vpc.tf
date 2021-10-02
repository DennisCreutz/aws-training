data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(
    local.default_tags,
    {
      Name = local.vpc_name
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = local.default_tags
}

# Public Subnet
resource "aws_subnet" "public_subnets" {
  count = length(local.public_subnet_cidrs)

  vpc_id = aws_vpc.this.id

  cidr_block              = local.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true

  tags = merge(
    local.default_tags,
    {
      Name = "${local.vpc_name}-pub-${count.index}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = local.default_tags
}
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table_association" "public_subnet" {
  count = length(local.public_subnet_cidrs)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}
