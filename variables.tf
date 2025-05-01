variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable env_zone {}
variable avail_zone{}
variable my_ip {}
variable public_key_path {}


# variable cidr_blocks {
#   description = "cidr blocks for vpc and subnets"
#   type = list(object({
#     cidr_block = string
#     name = string
#   })) 
# }