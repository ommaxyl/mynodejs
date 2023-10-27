# From the base image on dockerhub to build from and creating our own image
FROM node:18

# Create a directory inside the image that will hold the application code inside the image (Ou working directory).
WORKDIR /usr/src/app

# Copy package*.json (dependencies) inside the app folder to the workdir that was created inside our image
COPY package*.json ./

# The next stage is to run the app dependencies using npm binary in the image
RUN npm install

# Copy all the application inside the app folder to our work directory inside the image
COPY . .

# Binding our application to port 8080 for access and use expose command to expose our container mapped it using docker daemon
EXPOSE 8080

# Command to run the newly created image to start the server. node command and server.js file run.
CMD ["node", "server.js"]