FROM allenwoods/texlive:latest

# Install dependencies
USER root
RUN apt-get update && \
      apt-get -y dist-upgrade && \
      apt-get install -y \
          nodejs npm

# Install madoko
RUN npm install madoko -g
RUN npm install -g madoko-local

# Create config
EXPOSE 8080
RUN mkdir /madoko
VOLUME [ "/madoko" ]
COPY run.sh run.sh
RUN chmod +x run.sh
ENV secret="MADOKO_SECRET"
# ENV origin="https://www.madoko.net"
ENV origin="http://localhost:8080"


# Run madoko locally
USER texuser
CMD ./run.sh
