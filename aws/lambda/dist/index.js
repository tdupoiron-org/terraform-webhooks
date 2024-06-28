/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ 685:
/***/ ((module) => {

"use strict";
module.exports = require("http");

/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __nccwpck_require__(moduleId) {
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		// Execute the module function
/******/ 		var threw = true;
/******/ 		try {
/******/ 			__webpack_modules__[moduleId](module, module.exports, __nccwpck_require__);
/******/ 			threw = false;
/******/ 		} finally {
/******/ 			if(threw) delete __webpack_module_cache__[moduleId];
/******/ 		}
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	/* webpack/runtime/compat */
/******/ 	
/******/ 	if (typeof __nccwpck_require__ !== 'undefined') __nccwpck_require__.ab = __dirname + "/";
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it need to be isolated against other modules in the chunk.
(() => {
var exports = __webpack_exports__;
const http = __nccwpck_require__(685);

exports.handler = async (event) => {
  let response = {
    statusCode: 200,
    body: JSON.stringify("Event received"),
  }
  
  const parsedBody = JSON.parse(event.body);

  const data = JSON.stringify({
    '@timestamp': new Date(event.requestContext.requestTimeEpoch).toISOString(),
    event: parsedBody
  });

  const options = {
    hostname: 'elastic.dupoiron.com',
    port: 9200,
    path: '/github/_doc',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': data.length,
    }
  }

  const req = http.request(options, res => {
    console.log(`statusCode: ${res.statusCode}`)

    res.on('data', d => {
      process.stdout.write(d)
    })
  })

  req.on('error', error => {
    console.error(error)
    response = {
      statusCode: 500,
      body: JSON.stringify("An error occurred: " + error.message),
    }
  })

  req.write(data)
  req.end()

  return response
}
})();

module.exports = __webpack_exports__;
/******/ })()
;