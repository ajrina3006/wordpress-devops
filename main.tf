
provider "docker" {}



resource "docker_image" "wordpress_image" {

  name         = "myrepo/wordpress-custom:latest"

  keep_locally = true

}



resource "docker_container" "wordpress_app" {

  name  = "wordpress"

  image = docker_image.wordpress_image.name

  ports {

    internal = 80

    external = 8070

  }

}
