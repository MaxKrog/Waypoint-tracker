//Usage: node csvToJSON.js "path to csv-file".
//Outputs a new file from the csv with .json appended.

var fs = require("fs");

console.log(process.argv);
fs.readFile(process.argv[2], "utf8",  function(err, data){
	
	data = data.split("\n");

	var keys = data[0].split(",");
	data.splice(0, 1);
	var jsonArray = data.map(function(item, index){
		item = item.split(",");
		var json = {};
		item.map(function(item, index){
			var key = keys[index].toLowerCase()
			json[key] = item;
		})
		return json;
	})

	fs.writeFile(process.argv[2] + ".json", JSON.stringify(jsonArray, null, 4), function(err) {
		if(err) throw err;
		console.log("Done!");
	})
})