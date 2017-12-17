const Identity = require('fake-identity');
const fs = require('fs');
const randomMac = require('random-mac');
const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyA8IDCC5l9ZtWD_bQqaSNPur-iOOVUQB7U'
  });

function unique(arr){
  var obj = {};
    for (var i = 0; i < arr.length; i++) {
      var str = arr[i];
      obj[str] = true; 
    }
    return Object.keys(obj); 
}

let mac = [];
for(let i = 0; i < 5000000; i++ )
{
  let t = randomMac(i);
  // mac.forEach(element => {
  //   if(element === t)
  //     console.log("FUCK " + i);
  // });
  mac.push(t);
}
let res = unique(mac);
console.log(mac.length);
console.log(res.length);
// console.log(Identity.generate());
// console.log(Identity.generate());
// googleMapsClient.geocode({
//     address: 'ул. Каменногорская 100, Минск'
//   }, function(err, response) {
//     if (!err) {
//       console.log(response.json.results[0].geometry.location);
//     }
//   });