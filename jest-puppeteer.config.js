module.exports = {
    
    launch: {
        headless: true,//process.env.HEADLESS !== 'false',
        //devtools: process.env.DEVTOOLS ? true : false,
        defaultViewport: null,// {width: 960, height: 540},
        args: [
            '--window-size=1920,1080',
          ],
    },
    /*server: {
      command: 'node server.js',
      port: 1111,
    },*/
  }