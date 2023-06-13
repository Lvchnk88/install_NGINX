server {
    listen              80;
    server_name         sergio.html.com;
    return 301 https://sergio.html.com;

}

server {
    listen              443 ssl;
    server_name         sergio.html.com;
    ssl_certificate     /etc/ssl/certs/sergio.html.com.crt;
    ssl_certificate_key /etc/ssl/private/sergio.html.com.key;

    access_log /var/log/nginx/sergio.html.com.log;
    error_log  /var/log/nginx/sergio.html.com.log;

    root /usr/share/nginx/html;
    index sergio.html.com.html;

    location / {
        try_files $uri $uri/ =404;
            auth_basic "Restricted Content";
            auth_basic_user_file conf.d/.htpasswd;

    }
}
