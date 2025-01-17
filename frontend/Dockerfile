# Use nginx as a base image
FROM nginx:alpine

# Copy frontend files
COPY . /usr/share/nginx/html

# Expose the port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]