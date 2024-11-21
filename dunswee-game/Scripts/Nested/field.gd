extends Control

@export var grid : GridContainer
@export var enemyCount : int = 0;
@export var keyCount : int = 0;
@export var lowerBounds : int = 0;

var dataArray : Array = [];
var yHeight : int = 0;
var blankField : bool = true;
#00 == blank
#01-08 == enemy count
#10-80 == key count
#
#100 == enemy
#200 == key

func _ready() -> void:
	print(grid.get_child_count());
	registerTiles();
	print("building grid");
	yHeight = $ScrollContainer/GridContainer.columns;
	print(yHeight);
#	fill blank array wih increasing numbers


func setupField( tile:Control ):
	dataArray.resize(grid.get_child_count());
	dataArray.fill( 0 );

	var tempArray : Array = [];
	var enemyArray: Array = [];
	var keyArray: Array = [];
	
	tempArray.resize(grid.get_child_count() );
	#var n = 0
	for i in range(tempArray.size()):
		tempArray[i] = i;
		#n+=1

	var tempVal : int = 0;
	
#	PULL OUT THE INITAL CLICK GRID
	var n :int = 0;
	var c : int = 0;
	var xMin:int = 0;
	var xMax:int = 3;

	n = tile.getId();
	xMax = 7;
#		IF LEFT CUTS OFF
	for i in range(3,0,-1):
#		LEFT/RIGHT BOUNDS
		print("-",i,", ", isOutBoundsHoriz(n,-i))
		print("+",i,", ", isOutBoundsHoriz(n,+i))
			
		if(isOutBoundsHoriz(n,-i)):xMin=4-i;
		if(isOutBoundsHoriz(n,i)):xMax=3+i;

	var landingArray:Array = [];
	print("x's ", xMin, xMax)
	for x in range(xMin,xMax):
		for y in range(0,7):
			c = n+(-3+x)+(-(3*yHeight)+(yHeight*y));
			if ( c >= 0 and c < tempArray.size()):
				landingArray.append(c);
	print("old size ", tempArray.size())

	landingArray.sort();
	landingArray.reverse();
	for val in landingArray:
		tempArray.pop_at( val );
	
	
	print("new Size ", tempArray.size())


	for i in range(enemyCount):
		tempVal = randi()%tempArray.size();
		enemyArray.append( tempArray[tempVal]);
		tempArray.pop_at( tempVal );
	
	for i in range(keyCount):
		keyArray.append( tempArray.pop_at( randi()%tempArray.size() ));
	


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
		
#		IF LEFT/RIGHT CUTS OFF
		if (isOutBoundsHoriz(n, -1)): xMin +=1;
		if (isOutBoundsHoriz(n, 1)): xMax -=1;

#		ADD COUNTS -- BUG!!!!
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
	
	enemyArray.sort()
	print(enemyArray)
	print(dataArray)

func isOutBoundsHoriz( id, step ):
	if ((id+step < 0) or (id+step>=dataArray.size())): return false;
	return (ceil((id+step)/yHeight)< ceil(id/yHeight));
	
func isOutOfBoundsVert( id, step ):
	var stepSize = step*yHeight
	return !(id + stepSize >= 0 and id + stepSize < dataArray.size());

func tileClicked( tile:Control ):
	print(tile, "clicked")
	if (blankField):
		blankField = false;
		setupField( tile );
#	REVEAL
	tile.flip();
	floodFill(tile.getId(), true);
	

func floodFill(id, isStartingTile):
	if ((id>= 0) and (id<dataArray.size())):
		var l_tile:Control = grid.get_child(id);
		#print("tile type", l_tile.getTileType(), l_tile.getTileType() <= 0, l_tile.isCovered())
		
		if (l_tile.getTileType() <= 0 and (l_tile.isCovered() or isStartingTile)):
			grid.get_child(id).flip();
			if (!isOutBoundsHoriz(id,-1)): floodFill(id-1, false);
			if (!isOutBoundsHoriz(id, 1)): floodFill(id+1, false);
			if (!isOutOfBoundsVert(id,-1)): floodFill(id-yHeight, false);
			if (!isOutOfBoundsVert(id, 1)): floodFill(id+yHeight, false);
		elif (l_tile.getTileType() <= 1 and (l_tile.isCovered() or isStartingTile)):
			grid.get_child(id).flip();


func registerTiles():
	print("registering tiles")
	var i = 0;
	for tile in grid.get_children():
		tile.tileClicked.connect( tileClicked );
		tile.setId(i);
		tile.setLowerBounds(lowerBounds);
		i+=1;
