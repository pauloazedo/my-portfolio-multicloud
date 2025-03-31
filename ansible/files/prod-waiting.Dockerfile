FROM nginx:alpine
RUN echo "<h1>PROD server is ready. Waiting for Jenkins to publish the app...</h1>" > /usr/share/nginx/html/index.html