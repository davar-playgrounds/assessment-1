######### Sentry App Instance ######
resource "aws_eip" "sentry-public-ip" {
}
resource "aws_instance" "sentry-app" {
  ami           = "${data.aws_ami.basic_ami.id}"
  instance_type = "${var.instancetype}"
#  disable_api_termination = true
  key_name =  "${var.keypair}"
  vpc_security_group_ids = [ "${aws_security_group.sentry-app-sg.id}" ]
  subnet_id = "${aws_subnet.subnet1.id}"
  user_data          = "${data.template_file.init_template.rendered}"
  depends_on = [ "var.keypair", "aws_security_group.sentry-app-sg" ,"data.template_file.init_template" ]
  tags {
    Name = "sentrya-app"
    Env = "assesment"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.sentry-app.id}"
  allocation_id = "${aws_eip.sentry-public-ip.id}"
  depends_on = [ "aws_eip.sentry-public-ip", "aws_instance.sentry-app" ]
}
