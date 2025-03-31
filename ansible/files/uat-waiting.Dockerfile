FROM nginx:alpine
RUN echo "UAT server ready. Waiting for Jenkins to publish latest image..." > /usr/share/nginx/html/index.html