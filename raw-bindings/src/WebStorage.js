/* global exports */
"use strict";

// module WebStorage

exports.toStorage = function (storage) {
  return { clear: function() {
            storage.clear();
            return {};
           },
           getItem: function(key) {
            return function() {
              return storage.getItem(key);
            }
           },
           key: function(ix) {
             return function() {
               return storage.key(ix);
             }
           },
           length: function() {
             return storage.length;
           },
           removeItem: function(key) {
             return function() {
               storage.removeItem(key);
               return {};
             }
           },
           setItem: function(key) {
             return function(value) {
               return function() {
                 storage.setItem(key,value);
                 return {};
               }
             }
           }
        }
}
