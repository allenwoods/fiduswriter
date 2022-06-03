FROM node:latest

# Install dependencies
RUN apt-get update && \
      apt-get -y dist-upgrade && \
      apt-get install -y \
          imagemagick \
          inkscape \
          make \
          texlive-full
RUN apt-get install -y \
      inotify-tools \
      xzdec
RUN echo "deb http://cdn-fastly.deb.debian.org/debian jessie main contrib" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --allow-unauthenticated fonts-noto ttf-mscorefonts-installer

# Add external fonts
# https://tex.stackexchange.com/questions/27659/how-to-use-downloaded-fonts-with-xetex-on-ubuntu
RUN mkdir -p /usr/local/share/fonts/truetype/noto
RUN mkdir -p /usr/local/share/fonts/opentype/noto/
RUN wget -q https://github.com/googlefonts/noto-cjk/raw/main/Sans/Variable/OTC/NotoSansCJK-VF.ttf.ttc -P /usr/local/share/fonts/truetype/noto
RUN wget -q https://github.com/googlefonts/noto-cjk/raw/main/Sans/Variable/OTC/NotoSansMonoCJK-VF.ttf.ttc -P /usr/local/share/fonts/truetype/noto
RUN wget -q https://github.com/googlefonts/noto-cjk/raw/main/Sans/Variable/OTC/NotoSansCJK-VF.otf.ttc -P /usr/local/share/fonts/opentype/noto/
RUN wget -q https://github.com/googlefonts/noto-cjk/raw/main/Sans/Variable/OTC/NotoSansMonoCJK-VF.otf.ttc -P /usr/local/share/fonts/opentype/noto/
RUN chown -R 1000:1000 /usr/local/share/fonts/
RUN fc-cache -f -v
RUN tlmgr init-usertree

# Install madoko
RUN npm install madoko -g
RUN npm install -g madoko-local
COPY add_user add_user
RUN ./add_user
USER developer

EXPOSE 8080
RUN mkdir /madoko
VOLUME [ "/madoko" ]
COPY run.sh run.sh
RUN chmod +x run.sh
ENV secret="MADOKO_SECRET"
ENV origin="https://www.madoko.net"
CMD ./run.sh
