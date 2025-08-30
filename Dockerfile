FROM nginx:1.27-alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Add custom config for port 3000
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy prebuilt dist folder
COPY dist/ /usr/share/nginx/html

# Expose port 3000
EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
