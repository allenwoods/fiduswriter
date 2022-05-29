FROM node:5.11.0
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
# https://tex.stackexchange.com/questions/27659/how-to-use-downloaded-fonts-with-xetex-on-ubuntu
RUN wget -q https://github.com/googlei18n/noto-cjk/blob/master/NotoSansCJK.ttc.zip?raw=true -O NotoSansCJK.ttc.zip
RUN mkdir -p /usr/local/share/fonts/truetype/noto/ && unzip NotoSansCJK.ttc.zip -d /usr/local/share/fonts/truetype/noto/
# RUN cp -r noto-cjk/*.ttf /usr/local/share/fonts/truetype/noto/
RUN mkdir -p /usr/local/share/fonts/opentype/noto/ && \
      wget -q https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip && \
      wget -q https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip
RUN unzip -o NotoSerifCJKjp-hinted.zip -d /usr/local/share/fonts/opentype/noto/ && \
      unzip -o NotoSansCJKjp-hinted.zip -d /usr/local/share/fonts/opentype/noto/
RUN chown -R 1000:1000 /usr/local/share/fonts/
RUN fc-cache -f -v
RUN tlmgr init-usertree
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