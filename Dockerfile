# Use the official Nginx image as the base image
FROM nginx:latest

# Copy the current directory's contents to Nginx's default HTML directory
COPY . /usr/share/nginx/html

# Expose port 80 to allow access to the Nginx server
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

