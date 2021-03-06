provider "kubernetes" {
}

resource "kubernetes_pod" "echo" {
  metadata {
    name = "echo-example"
    labels {
      App = "echo"
    }
  }
  spec {
    container {
      image = "hashicorp/http-echo:0.2.1"
      name  = "example2"
      args = ["-listen=:80", "-text='Hello World'"]
      port {
        container_port = 80
      }
    }
  }
}

resource "kubernetes_service" "echo" {
  metadata {
    name = "echo-example"
  }
  spec {
    selector {
      App = "${kubernetes_pod.echo.metadata.0.labels.App}"
    }
    port {
        port        = 80
        target_port = 80
      }
    type = "NodePort"
    
    #type = ""
    #load_balancer_ip = "10.236.1.215"
  }
}


#output "lb_parameters" {
#  value = "${kubernetes_service.echo.load_balancer_ingress.0.ip}"
#  value = "${kubernetes_service.echo.load_balancer_ingress.0.hostname}"
#}
