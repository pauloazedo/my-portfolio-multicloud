# ansible/files/uat-waiting.Dockerfile

FROM nginx:alpine

# Use fallback config in the expected location
COPY default-waiting.conf /etc/nginx/conf.d/default.conf

# Set static fallback page content
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 3000