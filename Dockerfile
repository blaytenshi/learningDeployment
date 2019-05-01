# Multi-step Build process
# Two phases to build process

###############
# Build Phase #
###############
# the 'as' keyword indicates to Docker that everything that happens until the next FROM commans is known
# as the 'builder' phase
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .

RUN npm install

# no more volumes here, we're copying everything this time!
COPY . .

# once this line runs, all the built artifacts will be available in /app/build in the container
# this is the folder that we want to copy over to the run phase to be run and served up by nginx
RUN npm run build

#############
# Run Phase #
#############
FROM nginx

# here we're referencing builder phase and going into the /app/build and copying it into the default folder where nginx serves the files
COPY --from=builder /app/build /usr/share/nginx/html

# nginx is automatically started up for you as the default command is to start nginx therefore no need to include a RUN command

# now we can simply run docker build . because this is now the default Dockerfile that will be run