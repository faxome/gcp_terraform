#! /bin/bash

##---------------------------------------------------##
### Mounting additional disk on instance
##---------------------------------------------------##
mount_dir() {
        MNT_DIR=/mnt/disks/persistent_storage
        if [[ -d "$MNT_DIR" ]]; then
                return
        else
                sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb; \
                sudo mkdir -p $MNT_DIR
                sudo mount -o discard,defaults /dev/sdb $MNT_DIR
                # Add fstab entry
                echo UUID=`sudo blkid -s UUID -o value /dev/sdb` $MNT_DIR ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab
        fi
}
mount_dir

##---------------------------------------------------##
### Haproxy Configuration Setup
##---------------------------------------------------##
apt update
apt -y install haproxy
cat  > /etc/haproxy/haproxy.cfg <<EOF
global
  maxconn 10000
  nbthread 4
  stats socket /var/run/haproxy.sock mode 600 level admin
  stats timeout 60s
  log  /var/lib/haproxy/dev/log local0
defaults
  mode http
  option httplog
  log global
  option forwardfor header x-forwarded-for
  option http-server-close
  retries 3
  timeout queue 1m
  timeout connect 10s
  timeout client 4m
  timeout server 4m
frontend www-http
  bind 0.0.0.0:80
  mode http
  log global
  default_backend www-backend
  capture request header x-forwarded-for len 15
  log-format "%%{+Q}o\ client_address = %ci, client_port = %cp, start_of_http_req = [%tr], transport = %ft, backend_name = %b, server_name = %s, time_to_receive_full_req=%TR, wait_time_queues = %Tw, wait_time_final_connection = %Tc, response_time = %Tr, req_active_time = %Ta, status_code = %ST, bytes_read = %B, request_cookie = %CC, response_cookie = %CS, termination_cookie_status = %tsc, active_conc_conn = %ac, front_conc_conn = %fc, back_conc_conn = %bc, serv_conc_conn = %sc, retries = %rc, server_queue = %sq, backend_queue = %bq, req_headers = %hr, res_headers = %hs, request = %r"
backend www-backend
  mode http
  log global
  compression algo gzip
  http-request set-header x-client-ip %[req.hdr(x-forwarded-for,1)]
  server ssc ${ssc_ip}:443 ssl verify none
EOF
sudo service haproxy restart
