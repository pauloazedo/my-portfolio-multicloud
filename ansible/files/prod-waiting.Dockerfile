# ansible/files/prod-waiting.Dockerfile

FROM nginx:alpine

# Use shared fallback config
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Copy fallback index HTML
COPY prod-fallback-index.html /usr/share/nginx/html/index.html

EXPOSE 3000