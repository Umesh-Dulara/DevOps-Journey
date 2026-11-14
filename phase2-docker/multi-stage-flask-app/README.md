This is the same as previous flask app that count the visitors.
But the dockerfile is written in 2 stages as builder and runtime which reduce the image size by only copying installed libraries from the builder stage.
And the app is run by non root user.So it brings more security and less attack surface.
