# ansible/files/prod-waiting.Dockerfile

FROM nginx:alpine

# Replace NGINX config with shared fallback version
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Set custom HTML content
RUN echo "PROD server is ready. Waiting for Jenkins to publish the app..." > /usr/share/nginx/html/index.html

EXPOSE 3000