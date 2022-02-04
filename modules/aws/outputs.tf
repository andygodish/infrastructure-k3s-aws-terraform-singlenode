data "template_file" "init_server_userdata" {
  template = file("${path.module}/templates/init_server_userdata.sh")

  vars = {
    cp_lb_host = aws_elb.k3s_cp_elb.dns_name
    k3s_token = random_string.k3s_token.result
    region = var.region
  }
}

resource "local_file" "ssh_config" {
  content = templatefile("${path.module}/templates/ssh_config.tpl",
    {
      init_server_ip = aws_instance.init_server[0].public_ip
      user = var.amis[var.region][var.os].user
    }
  )
  filename = "ssh_config"
}