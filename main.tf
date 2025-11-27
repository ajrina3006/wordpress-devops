provider "docker" {}

# Pull image WordPress
resource "docker_image" "wordpress" {
  name         = "wordpress:php8.2-apache"
  keep_locally = true
}

# Pull image MariaDB
resource "docker_image" "mariadb" {
  name         = "mariadb:10.6"
  keep_locally = true
}

# Create persistent volume for DB
resource "docker_volume" "dbdata" {
  name = "dbdata"
}

# Create MariaDB container
resource "docker_container" "db" {
  name  = "db"
  image = docker_image.mariadb.name

  env = [
    "MYSQL_ROOT_PASSWORD=rootpass",
    "MYSQL_DATABASE=wpdb",
    "MYSQL_USER=wpuser",
    "MYSQL_PASSWORD=wppass"
  ]

  volumes {
    volume_name    = docker_volume.dbdata.name
    container_path = "/var/lib/mysql"
  }
}

# Create WordPress container
resource "docker_container" "wordpress" {
  name  = "wordpress"
  image = docker_image.wordpress.name

  ports {
    internal = 80
    external = 8070
  }

  env = [
    "WORDPRESS_DB_HOST=db:3306",
    "WORDPRESS_DB_USER=wpuser",
    "WORDPRESS_DB_PASSWORD=wppass",
    "WORDPRESS_DB_NAME=wpdb"
  ]

  depends_on = [
    docker_container.db
  ]
}
