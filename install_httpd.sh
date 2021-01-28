#! /bin/bash
sudo yum update
sudo yum install -y httpd
sudo chkconfig httpd on
sudo service httpd start
echo "<h1>Deployed via Terraform wih ELB</h1>" | sudo tee /var/www/html/index.html
sudo mkfs.ext4 /dev/xvdf
sudo mount /dev/xvdf /var/log
echo '/dev/xvdf /database ext4 defaults 0 0' >> /etc/fstab
