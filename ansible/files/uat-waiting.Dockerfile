# ansible/files/prod-waiting.Dockerfile

FROM nginx:alpine

# Replace NGINX config with shared fallback version
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Copy template HTML file that uses environment variable
COPY index.template.html /usr/share/nginx/html/index.template.html

# Entry point generates final index.html at container runtime
CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"]

EXPOSE 3000