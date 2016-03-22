FROM node

RUN git clone -b develop https://github.com/jbrjake/farstrider.git /usr/local/src/farstrider

RUN cd /usr/local/src/farstrider/farstrider-server; npm install

CMD node /usr/local/src/farstrider/farstrider-server/index.js

