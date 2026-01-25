provider "aws" {
  
}
resource "aws_db_instance" "db" {
    identifier     = "mydatabase"
    instance_class = "db.t3.micro"
    engine         = "mysql"
    engine_version = "8.0"
    username       = "admin"
    password       = "password123"
    allocated_storage = 20
    skip_final_snapshot = true
    delete_automated_backups = true
    tags = {
        Name = "opemtofu-database"
    }
} 


resource "aws_db_instance" "replica" {
  identifier = "db-replica"
    instance_class = "db.t3.micro"
    engine         = "mysql"
    replicate_source_db = aws_db_instance.db.id
    tags = {
        Name = "opentofu-replica-database"
    }
}