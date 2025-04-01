# ansible/files/uat-waiting.Dockerfile

FROM nginx:alpine

# Copy full NGINX config to expected path
COPY default-waiting.conf /etc/nginx/nginx.conf

# Set static fallback page content
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 3000