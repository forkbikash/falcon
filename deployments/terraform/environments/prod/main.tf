# module "vpc" {
#   source = "./modules/vpc"

#   # Module input variables
#   vpc_cidr_block             = var.vpc_cidr_block
#   private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
#   public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks

#   # Module output variables
#   vpc_id             = module.vpc.vpc_id
#   private_subnet_ids = module.vpc.private_subnet_ids
#   public_subnet_ids  = module.vpc.public_subnet_ids
# }

# Define the subnet resources
# module "subnets" {
#   source = "./modules/subnets"

#   vpc_id          = module.vpc.vpc_id
#   public_subnets  = var.public_subnets
#   private_subnets = var.private_subnets
# }


module "ec2_security_group" {
  source = "../../modules/securitygroup"

  # Module input variables
  # vpc_id        = module.vpc.vpc_id
  ingress_rules = var.ec2_security_group_ingress_rules
  egress_rules  = var.ec2_security_group_egress_rules
  description   = var.ec2_sg_description
  name          = var.ec2_sg_name
}
module "falcon_ec2_security_group" {
  source = "../../modules/securitygroup"

  # Module input variables
  # vpc_id        = module.vpc.vpc_id
  ingress_rules = var.falcon_ec2_security_group_ingress_rules
  egress_rules  = var.falcon_ec2_security_group_egress_rules
  description   = var.falcon_ec2_sg_description
  name          = var.falcon_ec2_sg_name
}

module "aws_key_pair" {
  source = "../../modules/keypair"

  # Module input variables
  key_name   = var.key_name
  public_key = file("${path.module}/keys/id_rsa.pub")
}
module "falcon_aws_key_pair" {
  source = "../../modules/keypair"

  # Module input variables
  key_name   = var.falcon_key_name
  public_key = file("${path.module}/keys/falcon_id_rsa.pub")
}

module "ec2_instance" {
  source = "../../modules/ec2instance"

  # Module input variables
  # vpc_id             = module.vpc.vpc_id
  # subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.ec2_security_group.security_group_id]
  ami_id             = var.ec2_ami_id
  instance_type      = var.ec2_instance_type
  key_name           = module.aws_key_pair.ssh_key_name
  user_data          = file("${path.module}/script/user_data.sh")
  name               = var.ec2_instance_name
}
module "falcon_ec2_instance" {
  source = "../../modules/ec2instance"

  # Module input variables
  # vpc_id             = module.vpc.vpc_id
  # subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.falcon_ec2_security_group.security_group_id]
  ami_id             = var.falcon_ec2_ami_id
  instance_type      = var.falcon_ec2_instance_type
  key_name           = module.falcon_aws_key_pair.ssh_key_name
  user_data          = file("${path.module}/script/user_data.sh")
  name               = var.falcon_ec2_instance_name
}


module "aws_iam_user_ses" {
  source = "../../modules/iamuser"

  # Module input variables
  iam_user = var.iam_user_ses
}

module "aws_iam_group_ses" {
  source = "../../modules/iamgroup"

  # Module input variables
  iam_group = var.iam_group_ses
}

module "iam_user_group_membership_ses" {
  source = "../../modules/iamusergroup"

  # Module input variables
  iam_user_group_membership_user   = module.aws_iam_user_ses.name
  iam_user_group_membership_groups = [module.aws_iam_group_ses.name]
}

module "iam_group_policy_attachment_ses_full_access" {
  source = "../../modules/iamgrouppolicy"

  policy_group = module.aws_iam_group_ses.name
  policy_arn   = var.iam_policy_arn_ses_full_access
}

module "rds_security_group" {
  source = "../../modules/securitygroup"

  # Module input variables
  # vpc_id        = module.vpc.vpc_id
  ingress_rules = [{
    description      = "Traffic from ec2"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [module.ec2_security_group.security_group_id]
    cidr_blocks      = []
    ipv6_cidr_blocks = []
  }]

  egress_rules = var.rds_security_group_egress_rules
  description  = var.rds_sg_description
  name         = var.rds_sg_name
}

module "rds_instance" {
  source = "../../modules/rds"

  # Module input variables
  instance_identifier     = var.rds_instance_identifier
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_instance_class
  username                = var.rds_username
  password                = var.rds_password
  allocated_storage       = var.rds_allocated_storage
  storage_type            = var.rds_storage_type
  vpc_security_group_ids  = [module.rds_security_group.security_group_id]
  name                    = var.rds_name
  backup_retention_period = var.rds_backup_retention_period
  # db_subnet_group_name   = module.vpc.db_subnet_group_name
  # db_name                = "prod_db"
  # skip_final_snapshot    = false
}

module "aws_eip" {
  source = "../../modules/elasticip"

  # Module input variables
  is_for_vpc = var.is_for_vpc
}
module "falcon_aws_eip" {
  source = "../../modules/elasticip"

  # Module input variables
  is_for_vpc = var.falcon_is_for_vpc
}

module "aws_eip_association" {
  source = "../../modules/elasticipassociation"

  # Module input variables
  ec2_instance_id = module.ec2_instance.id
  eip_id          = module.aws_eip.id
}
module "falcon_aws_eip_association" {
  source = "../../modules/elasticipassociation"

  # Module input variables
  ec2_instance_id = module.falcon_ec2_instance.id
  eip_id          = module.falcon_aws_eip.id
}


module "aws_iam_user_s3" {
  source = "../../modules/iamuser"

  # Module input variables
  iam_user = var.iam_user_s3
}
module "falcon_aws_iam_user_s3" {
  source = "../../modules/iamuser"

  # Module input variables
  iam_user = var.falcon_iam_user_s3
}

module "aws_iam_group_s3" {
  source = "../../modules/iamgroup"

  # Module input variables
  iam_group = var.iam_group_s3
}
module "falcon_aws_iam_group_s3" {
  source = "../../modules/iamgroup"

  # Module input variables
  iam_group = var.falcon_iam_group_s3
}

module "iam_user_group_membership_s3" {
  source = "../../modules/iamusergroup"

  # Module input variables
  iam_user_group_membership_user   = module.aws_iam_user_s3.name
  iam_user_group_membership_groups = [module.aws_iam_group_s3.name]
}
module "falcon_iam_user_group_membership_s3" {
  source = "../../modules/iamusergroup"

  # Module input variables
  iam_user_group_membership_user   = module.falcon_aws_iam_user_s3.name
  iam_user_group_membership_groups = [module.falcon_aws_iam_group_s3.name]
}

module "iam_group_policy_attachment_s3_full_access" {
  source = "../../modules/iamgrouppolicy"

  # Module input variables
  policy_group = module.aws_iam_group_s3.name
  policy_arn   = var.iam_policy_arn_s3_full_access
}
module "falcon_iam_group_policy_attachment_s3_full_access" {
  source = "../../modules/iamgrouppolicy"

  # Module input variables
  policy_group = module.falcon_aws_iam_group_s3.name
  policy_arn   = var.falcon_iam_policy_arn_s3_full_access
}


module "s3_bucket" {
  source = "../../modules/s3bucket"

  # Module input variables
  bucket = var.bucket
}
module "falcon_s3_bucket" {
  source = "../../modules/s3bucket"

  # Module input variables
  bucket = var.falcon_bucket
}

module "s3_bucket_ownership_controls" {
  source = "../../modules/s3bucketownershipcontrols"

  # Module input variables
  bucket_id                                          = module.s3_bucket.id
  s3_bucket_ownership_controls_rule_object_ownership = var.s3_bucket_ownership_controls_rule_object_ownership
}
module "falcon_s3_bucket_ownership_controls" {
  source = "../../modules/s3bucketownershipcontrols"

  # Module input variables
  bucket_id                                          = module.falcon_s3_bucket.id
  s3_bucket_ownership_controls_rule_object_ownership = var.falcon_s3_bucket_ownership_controls_rule_object_ownership
}

# module "s3_bucket_public_access_block" {
#   source = "../../modules/s3bucketpublicaccessblock"

#   # Module input variables
#   bucket_id               = module.s3_bucket.id
#   block_public_acls       = var.block_public_acls
#   block_public_policy     = var.block_public_policy
#   ignore_public_acls      = var.ignore_public_acls
#   restrict_public_buckets = var.restrict_public_buckets
# }

module "s3_bucket_acl" {
  source = "../../modules/s3bucketacl"

  # Module input variables
  depends_on = [
    module.s3_bucket_ownership_controls,
    # module.s3_bucket_public_access_block,
  ]
  bucket_id     = module.s3_bucket.id
  s3_bucket_acl = var.s3_bucket_acl
}
module "falcon_s3_bucket_acl" {
  source = "../../modules/s3bucketacl"

  # Module input variables
  depends_on = [
    module.falcon_s3_bucket_ownership_controls,
    # module.s3_bucket_public_access_block,
  ]
  bucket_id     = module.falcon_s3_bucket.id
  s3_bucket_acl = var.falcon_s3_bucket_acl
}

# module "s3_bucket_policy" {
#   source = "../../modules/s3bucketpolicy"

#   # Module input variables
#   bucket_id = module.s3_bucket.id
#   bucket_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect    = "Allow"
#         Principal = "*"
#         Action = [
#           "s3:GetObject"
#         ]
#         Resource = "${module.s3_bucket.arn}/*"
#         Condition = {
#           "StringEquals" : {
#             "aws:Referer" : "${var.s3_referer}"
#           }
#         }
#       }
#     ]
#   })
# }
