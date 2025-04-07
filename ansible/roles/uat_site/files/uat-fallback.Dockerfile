FROM nginx:alpine

COPY default-waiting.conf /etc/nginx/conf.d/default.conf
COPY index.template.html /usr/share/nginx/html/index.template.html

CMD ["/bin/sh", "-c", "envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"]

EXPOSE 3000