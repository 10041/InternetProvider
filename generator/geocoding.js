const googleMapsClient = require('@google/maps').createClient({
    key: 'AIzaSyA8IDCC5l9ZtWD_bQqaSNPur-iOOVUQB7U'
  });
//улица Свердлова 13а, Минск        //53.891500, 27.559719
//ул. Каменногорская 100, Минск     //53.93236750000001, 27.4284223
let addr = 'ул. Каменногорская 100, Минск'

googleMapsClient.geocode({
    address: addr
  }, function(err, response) {
    if (!err) {
      console.log(response.json.results[0].geometry.location);
    }
  });