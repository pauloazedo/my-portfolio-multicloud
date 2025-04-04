FROM nginx:alpine

# Use shared fallback NGINX config
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Copy the fully rendered fallback page
COPY prod-fallback-index.html /usr/share/nginx/html/index.html

EXPOSE 3000