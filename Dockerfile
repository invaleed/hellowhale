FROM nginx

COPY wrapper.sh /

COPY html /usr/share/nginx/html

EXPOSE 9000

CMD ["./wrapper.sh"]
