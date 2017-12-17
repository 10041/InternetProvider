
//const sql = require('mssql/msnodesqlv8');

// function unique(arr){
//   var obj = {};
//     for (var i = 0; i < arr.length; i++) {
//       var str = arr[i];
//       obj[str] = true; 
//     }
//     return Object.keys(obj); 
// }

// let mac = [];
// for(let i = 0; i < 10; i++ )
// {
//   let mac = randomMac(randomMac(` `));
//   let arr = mac.split(':')
//   arr.splice(0, 1);
//   mac = arr.join(':');
//   console.log(mac);
// }

// let res = unique(mac);
// console.log(mac.length);
// console.log(res.length);

// console.log(Identity.generate());
// console.log(Identity.generate());
          
          //  const result = await sql.query`exec dbo.AddUser 
          //  '${data.firstName}', 
          //  '${data.lastName}', 
          //  'Vic${i}', 
          //  '22.10.1997', 
          //  'tariff${tariffID}', 
          //  '${data.phoneNumber}', 
          //  '${i}${data.emailAddress}', 
          //  '${mac}', 
          //  '127.0.0.1', 
          //  'IPv6', 
          //  'login${i}', 
          //  '12345', 
          //  ${p1 + 53}, 
          //  ${p2 + 27};`;
      //const pool = await sql.connect('Driver=SQL Server Native Client 11.0.2218.0;Server=DESKTOP-L5ROMAE;Database=InternetProvider;Trusted_Connection=yes;');
      
const Identity = require('fake-identity');
const fs = require('fs');
const randomMac = require('random-mac');
let count = 100000;
 aa = async () => {
     try {
          let tariffID = 1
         
         fs.truncateSync('res.sql');
         fs.appendFileSync('res.sql', 'use InternetProvider;');
         for(let i = 0; i < count; i++){
           let p1 = Math.random();
           let p2 = Math.random();
           if(tariffID === 4){
            tariffID = 1;
           }
           let data = Identity.generate();

           let mac = randomMac(randomMac(` `));
           let arr = mac.split(':')
           arr.splice(0, 1);
           mac = arr.join(':');

          let str = `
          exec dbo.AddUser 
          '${data.firstName}', 
          '${data.lastName}', 
          'Vic${i}', 
          '22.10.1997', 
          'tariff${tariffID}', 
          '${data.phoneNumber}', 
          '${i}${data.emailAddress}', 
          '${mac}', 
          '127.0.0.1', 
          'IPv6', 
          'login${i}', 
          '12345', 
          ${p1 + 53}, 
          ${p2 + 27}`;
          fs.appendFileSync('res.sql', str);

           tariffID++;
         }
         console.log("done");
     } catch (err) {
         console.log(err)
         console.log("err");
     }
 }

 let res = aa()