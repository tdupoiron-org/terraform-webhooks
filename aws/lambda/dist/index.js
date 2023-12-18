/******/ (() => { // webpackBootstrap
/******/ 	/* webpack/runtime/compat */
/******/ 	
/******/ 	if (typeof __nccwpck_require__ !== 'undefined') __nccwpck_require__.ab = __dirname + "/";
/******/ 	
/************************************************************************/
var __webpack_exports__ = {};
// This entry need to be wrapped in an IIFE because it uses a non-standard name for the exports (exports).
(() => {
var exports = __webpack_exports__;
exports.handler = async (event) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify("Hello from Lambda and Github!"),
  }
  return response
}
})();

module.exports = __webpack_exports__;
/******/ })()
;