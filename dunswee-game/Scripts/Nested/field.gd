extends Control

@export var grid : GridContainer
@export var enemyCount : int = 0;
@export var keyCount : int = 0;

var dataArray : Array = []
var yHeight : int = 0;
#00 == blank
#01-08 == enemy count
#10-80 == key count
#
#100 == enemy
#200 == key

func _ready() -> void:
	print(grid.get_child_count());
	print("building grid");
	yHeight = $ScrollContainer/GridContainer.columns;
	print(yHeight);
#	fill blank array wih increasing numbers
	var tempArray : Array = [];
	var enemyArray: Array = [];
	var keyArray: Array = [];
	
	tempArray.resize(grid.get_child_count() );
	#var n = 0
	for i in range(tempArray.size()):
		tempArray[i] = i;
		#n+=1

	var tempVal : int = 0;

	for i in range(enemyCount):
#		randi() % 20      # Returns random integer between 0 and 19
		tempVal = randi()%tempArray.size();
		enemyArray.append( tempArray[tempVal]);
		tempArray.pop_at( tempVal );
	
	for i in range(keyCount):
#		randi() % 20      # Returns random integer between 0 and 19
		keyArray.append( tempArray.pop_at( randi()%tempArray.size() ));
	
	print("enemies at", enemyArray);
	print("keys at", keyArray);
	dataArray.resize(grid.get_child_count());
	dataArray.fill( 0 );
	
	var n :int = 0;
	var c : int = 0;
	var xMin:int = 0;
	var xMax:int = 3;
	
	for i in range(enemyArray.size()):
		n = enemyArray[i];
#		ADD ENEMY
		dataArray[n] = 100;
		xMin = 0;
		xMax = 3;
		
#		IF LEFT CUTS OFF
		if( ceil((n-1)/yHeight)< ceil(n/yHeight)): xMin +=1;
#		IF RIGHT CUTS OFF
		if( ceil((n+1)/yHeight)> ceil(n/yHeight)): xMax -=1;

#		ADD COUNTS
		for x in range(xMin,xMax):
			for y in range(0,3):
				c = n+(-1+x)+(-yHeight+(yHeight*y));
				if ( c >= 0 and c < dataArray.size()):
#					IS NOT FLAGGED AS ENEMY OR KEY
					if dataArray[c] < 100:
						dataArray[c] +=1;


	for i in range(keyArray.size()):
		n = keyArray[i];
		#dataArray[keyArray[i]] = 200;
#		ADD ENEMY
		dataArray[n] = 200;
		xMin = 0;
		xMax = 3;
		
#		IF LEFT CUTS OFF
		if( ceil((n-1)/yHeight)< ceil(n/yHeight)): xMin +=1;
#		IF RIGHT CUTS OFF
		if( ceil((n+1)/yHeight)> ceil(n/yHeight)): xMax -=1;

#		ADD COUNTS
		for x in range(xMin,xMax):
			for y in range(0,3):
				c = n+(-1+x)+(-yHeight+(yHeight*y));
				if ( c >= 0 and c < dataArray.size()):
#					IS NOT FLAGGED AS ENEMY OR KEY
					if dataArray[c] < 100:
						dataArray[c] +=10;
	
#	SET TILE VALUES
	for i in range(dataArray.size()):
		grid.get_child(i).setValue( dataArray[i] );
	
	print(dataArray)
