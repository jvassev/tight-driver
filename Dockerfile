FROM ubuntu:16.04

EXPOSE 5901 6080 4444
VOLUME /tmp/.X11-unix
ENTRYPOINT ["tini", "--", "/home/test/start.sh"]
ENV GEOMETRY=1920x1200 SESSION_NAME=no-name USER=test VNC_PASS=123456

RUN apt-get update
RUN apt-get -y install tightvncserver x11-apps ratpoison xterm autocutsel
RUN apt-get -y install unzip curl git net-tools python

RUN useradd test -m -s /bin/bash

# install & configure webvnc
RUN mkdir -p /home/test/.vnc && \
    echo "$VNC_PASS" | vncpasswd -f > /home/test/.vnc/passwd && \
    chmod go-rwx /home/test/.vnc/passwd
RUN git clone https://github.com/kanaka/noVNC.git --depth 1      /home/test/novnc  && \
    git clone https://github.com/kanaka/websockify.git --depth 1 /home/test/novnc/utils/websockify

ENV TINI_VERSION=v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini


# Install Chrome WebDriver
ENV CHROMEDRIVER_VERSION=2.24
RUN mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -y update && \
    apt-get -y install google-chrome-stable && \
	rm -rf /var/lib/apt/lists/*

# Disable the SUID sandbox so that Chrome can launch without being in a privileged container.
# One unfortunate side effect is that `google-chrome --help` will no longer work.
RUN dpkg-divert --add --rename --divert /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome && \
    echo "#!/bin/bash\nexec /opt/google/chrome/google-chrome.real --no-sandbox \"\$@\"" > /opt/google/chrome/google-chrome && \
    chmod 755 /opt/google/chrome/google-chrome


COPY xstartup /home/test/.vnc/
COPY vnc_auto.html  /home/test/novnc/index.html
RUN chown test. -Rv /home/test/

COPY start.sh /home/test/

USER test
WORKDIR /home/test
