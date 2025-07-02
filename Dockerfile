# Use the official Nginx image as a base
FROM nginx:alpine

# Copy the web application files to the Nginx default directory
COPY app/usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
