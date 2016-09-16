# What's this?
This is a containerized chrome-driver + chrome browser + vnc + webvnc package.

# How do you use it?
```
docker run -ti --rm -p 4444:4444 -p 6080:6080 jvassev/tight-driver
```
4444 is the default Selenium port, 6080 is the port where vnc over http is served.

# How do I make sure it works?
Assuming you have your tight-driver container running try this (it requires nodejs):
```
curl -O https://raw.githubusercontent.com/jvassev/tight-driver/master/example.js

node install webdriverio
node example.js
```

Ths `example.js` will talk to the selenium/chrome-driver running containerized. You should see output looking like this:
```
=======================================================================================
Selenium 2.0 / webdriver protocol bindings implementation with helper commands in nodejs.
For a complete list of commands, visit http://webdriver.io/api.html.
=======================================================================================

[14:01:00]  COMMAND	POST 	 "/wd/hub/session"
[14:01:00]  DATA		{"desiredCapabilities":{"javascriptEnabled":true,"locationContextEnabled":true,"handlesAlerts":true,"rotatable":true,"browserName":"chrome","loggingPrefs":{"browser":"ALL","driver":"ALL"},"requestOrigins":{"url":"http://webdriver.io","version":"4.2.14","name":"webdriverio"}}}
[14:01:00]  INFO	SET SESSION ID 8a63a8899234662d0af58d205379e278
[14:01:00]  RESULT		{"acceptSslCerts":true,"applicationCacheEnabled":false,"browserConnectionEnabled":false,"browserName":"chrome","chrome":{"chromedriverVersion":"2.24.417424 (c5c5ea873213ee72e3d0929b47482681555340c3)","userDataDir":"/tmp/.org.chromium.Chromium.hX3UqO"},"cssSelectorsEnabled":true,"databaseEnabled":false,"handlesAlerts":true,"hasTouchScreen":false,"javascriptEnabled":true,"locationContextEnabled":true,"mobileEmulationEnabled":false,"nativeEvents":true,"networkConnectionEnabled":false,"pageLoadStrategy":"normal","platform":"Linux","rotatable":false,"takesHeapSnapshot":true,"takesScreenshot":true,"version":"53.0.2785.116","webStorageEnabled":true}
[14:01:00]  COMMAND	POST 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/url"
[14:01:00]  DATA		{"url":"https://duckduckgo.com/"}
[14:01:03]  RESULT		null
[14:01:03]  COMMAND	POST 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/elements"
[14:01:03]  DATA		{"using":"id","value":"search_form_input_homepage"}
[14:01:03]  RESULT		[{"ELEMENT":"0.279484484519376-1"}]
[14:01:03]  COMMAND	POST 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/element/0.279484484519376-1/clear"
[14:01:03]  DATA		{}
[14:01:03]  RESULT		null
[14:01:03]  COMMAND	POST 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/element/0.279484484519376-1/value"
[14:01:03]  DATA		{"value":["W","e","b","d","r","i","v","e","r","I","(1 more items)"]}
[14:01:04]  RESULT		null
[14:01:04]  COMMAND	POST 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/element"
[14:01:04]  DATA		{"using":"id","value":"search_button_homepage"}
[14:01:04]  RESULT		{"ELEMENT":"0.279484484519376-2"}
[14:01:04]  COMMAND	POST 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/element/0.279484484519376-2/click"
[14:01:04]  DATA		{}
[14:01:08]  RESULT		null
[14:01:08]  COMMAND	GET 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278/title"
[14:01:08]  DATA		{}
[14:01:08]  RESULT		"WebdriverIO at DuckDuckGo"
Title is: WebdriverIO at DuckDuckGo
[14:01:08]  COMMAND	DELETE 	 "/wd/hub/session/8a63a8899234662d0af58d205379e278"
[14:01:08]  DATA		{}
[14:01:08]  RESULT		null
```

Try running `node example.js` again but this time go to http://localhost:6080. This is a vnc-over-web endpoint and you can see your selenium script executing in a real browser.
The screenshot bellow shows the output of the nodejs command in the foreground and in the background and a vnc over html5/websockets.
![screenshot](https://raw.githubusercontent.com/jvassev/tight-driver/master/screenshot.png)

# How should I use it?
You can run this locally (or in docker-machine) to get your tests right. Then, using the same image you can execute tests in a CI pipeline. It's best to run one tight-driver per jenkins worker or start/stop a container per job run.

There are two env variables that affect behaviour when passed to docker run: `GEOMETRY` and `SESSION_NAME`. Default value for GEOMETRY is 1920x1200. The SESSION_NAME affects what your VNC client will show as session name.

# Hacking
Use the make file:
* `make build` builds the image
* `make run` builds the image and run it
* `make info` prints a useful info from the last `make run`
* `make stop` kills the container
* `make vnc` starts a `vncviewer` to the current container
* `make logs` shows container logs
* `make attach` starts an interactive shell into the current container (started via `make run`)
* `make shell` start a new temporary container (`--rm`) as root

# Resources
* [docker-chromedriver](https://hub.docker.com/r/robcherry/docker-chromedriver/) The inspiration for this project. I've chose to make it less configurable (assuming the defaults for you) and fixed a trivial issue
* [TightVNC](http://www.tightvnc.com/) A vnc server that comes with a minimal X server.
* [Tini](https://github.com/krallin/tini) A tiny but valid `init` for containers
* [noVNC](https://github.com/kanaka/noVNC) VNC client over html5/websockets
* [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) WebDriver for Chrome
* [ratpoison](http://www.nongnu.org/ratpoison/) A tiny window manager that hosts you X session inside the X server inside TightVnc. `C-t C-c` will pop a xterm for you if you need to look around. Use `C-t C-n` to go the next window.