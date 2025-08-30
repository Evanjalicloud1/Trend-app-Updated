FROM nginx:1.27-alpine

# remove default config
RUN rm /etc/nginx/conf.d/default.conf

# add custom config for port 3000
COPY nginx.conf /etc/nginx/conf.d/default.conf

# copy dist files
COPY dist/ /usr/share/nginx/html

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
