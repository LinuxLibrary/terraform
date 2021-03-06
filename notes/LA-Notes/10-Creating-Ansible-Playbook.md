# Creating Ansible Playbook for wordpress

- Below are the required steps for a wordpress site
	- Hosts: dev
	- Sudo: yes
	- SSH_User: ec2-user
	- Install `httpd, php, php-mysql`
	- Restart `httpd` through handler
	- Download wordpress
	- Extract wordpress
	- Change the permissions for `/var/www/html` directory
- Below is the ansible playbook for the above requirements

```
--- # Playbook for installing and configuring Wordpress
- hosts: dev
  remote_user: ec2-user
  become: yes
  tasks:
    - name: Install Apache
      yum: name=httpd state=latest
    - name: Install additional packages
      yum: name={{ item }} state=latest
      with_items:
      - php
      - php-mysql
    - name: Download wordpress
      get_url: url=http://wordpress.org/wordpress-latest.tar.gz dest=/var/www/html/wordpress-latest.tar.gz force=yes
    - name: Extract wordpress
      shell: "tar xzf /var/www/html/wordpress-latest.tar.gz -C /var/www/html --strip-components 1"
    - name: Make my Document Root readable
      file:
        path: /var/www/html
        mode: u=rwX,g=rX,o=rX
        recurse: yes
        owner: apache
        group: apache
      notify: Restart HTTPD
  handlers:
    - name: Restart HTTPD
      service: name=httpd enabled=yes state=restarted
...
```
