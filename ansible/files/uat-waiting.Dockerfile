# ansible/files/uat-waiting.Dockerfile

FROM nginx:alpine

# Use shared fallback NGINX config
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Copy UAT fallback HTML template using $FALLBACK_COLOR
COPY uat-fallback-index.html /usr/share/nginx/html/index.template.html

# Generate index.html dynamically using environment variable
CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"]

EXPOSE 3000