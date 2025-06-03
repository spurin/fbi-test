FROM nginx:latest

# Copy the nginx config
COPY default.conf.template /etc/nginx/conf.d/default.conf

# Copy the static HTML page
COPY index.nginx.html /usr/share/nginx/html/index.html
