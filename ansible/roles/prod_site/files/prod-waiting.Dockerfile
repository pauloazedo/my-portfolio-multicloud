# ansible/roles/prod_site/files/prod-waiting.Dockerfile
FROM nginx:stable-alpine

# Use shared fallback NGINX config
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Copy the template to render at runtime
COPY prod-fallback-index.html /usr/share/nginx/html/index.template.html

# Runtime template rendering using environment variables
CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"]

EXPOSE 3000