build {
  sources = [
    "source.amazon-ebs.builder",
  ]

  provisioner "ansible" {
    groups        = ["${var.configuration_group}"]
    playbook_file = "${var.playbook_file_path}"
    use_proxy     = false
    extra_arguments = [
      "-e", "aws_region=${var.aws_region}",
      "--skip-tags", "add-key"
    ]
    ansible_env_vars = [
      "ANSIBLE_FORCE_COLOR=true",
      "ANSIBLE_STDOUT_CALLBACK=default",
      "ANSIBLE_CALLBACK_RESULT_FORMAT=yaml",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_PYTHON_INTERPRETER=auto_silent",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo find /root /home -name authorized_keys -delete",
      "sudo find /root /home -name '.*history' -delete"
    ]
    remote_folder = "/home/ec2-user"
    remote_file   = "cleanup.sh"
  }
}
