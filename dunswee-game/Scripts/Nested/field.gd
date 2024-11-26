extends Control

signal flagged( type:int )
signal unflagged( type:int )
signal hit(type:int )

@export var grid : GridContainer;

@export var lowerBounds : int = 0;
@export var playNode: Control;

var readyToPlay : int = false;
var dataArray : Array = [];
var enemyArray: Array = [];
var keyArray: Array = [];
var yHeight : int = 0;
var blankField : bool = true;
enum FlagTypes {UNMARKED, ENEMY, KEY};
enum ActionTypes {BASIC, FLAGENEMY, FLAGKEY, ESCAPE};
enum TileTypes {EMPTY, MARKED, ENEMY, KEY, HEALTH};
var enemyCount : int = 0;
var keyCount : int = 0;
#00 == blank
#01-08 == enemy count
#10-80 == key count
#
#100 == enemy
#200 == key

func _ready() -> void:
	$"../../StallStart".start();
	enemyCount = playNode.getCount(TileTypes.ENEMY);
	keyCount = playNode.getCount(TileTypes.KEY);

	print(grid.get_child_count());
	registerTiles();
	print("building grid");
	yHeight = $ScrollContainer/GridContainer.columns;
	print(yHeight);
#	fill blank array wih increasing numbers

func getRemainingEnemies()->Array:
	if (blankField):
		blankField = false;
		setupField( grid.get_child( randi()%(grid.get_child_count()-1) ) );

	var remaining : Array = [];
	for i in range(enemyArray.size()):
		var tile : Control = grid.get_child( enemyArray[i] );
		if !tile.isFlaggedCorrectly():
#			ADD THE TILE
			remaining.append(grid.get_child(enemyArray[i]));
	return remaining;

func getRemainingKeys()->Array:
	if (blankField):
		blankField = false;
		setupField( grid.get_child( randi()%(grid.get_child_count()-1) ) );

	var remaining : Array = [];
	for i in range(keyArray.size()):
		var tile : Control = grid.get_child( keyArray[i] );
		if !tile.isFlaggedCorrectly():
#			ADD THE TILE
			remaining.append(grid.get_child(keyArray[i]));
	return remaining;

func setupField( tile:Control ):
	dataArray.resize(grid.get_child_count());
	dataArray.fill( 0 );

	var tempArray : Array = [];

	
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
		

		#IF LEFT CUTS OFF
		if( ceil((n-1)/yHeight)< ceil(n/yHeight)): xMin +=1;
#		IF RIGHT CUTS OFF
		if( ceil((n+1)/yHeight)> ceil(n/yHeight)): xMax -=1;

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
	
	if (readyToPlay):
		#print(tile, "clicked")
		match playNode.getCurrentAction():
			ActionTypes.BASIC:
				if (blankField):
					blankField = false;
					setupField( tile );
			#	REVEAL
				if(playNode.isAlive()):
					tile.flagTile(FlagTypes.UNMARKED);
					#tile.flip();
					if(tile.getTileType()==TileTypes.ENEMY or tile.getTileType()==TileTypes.KEY):
						emit_signal("hit", tile.getTileType() );
					floodFill(tile.getId(), true);
				
			ActionTypes.FLAGENEMY:
				if (tile.getFlag() == FlagTypes.ENEMY ): emit_signal("unflagged", FlagTypes.ENEMY);
				if(playNode.hasFlagsRemaining(FlagTypes.ENEMY)):
					if (tile.getFlag() != FlagTypes.ENEMY ): emit_signal("flagged", FlagTypes.ENEMY);
					if (tile.getFlag() == FlagTypes.KEY): emit_signal("unflagged", FlagTypes.KEY);
					tile.flagTile(FlagTypes.ENEMY);

			ActionTypes.FLAGKEY:
				if (tile.getFlag() == FlagTypes.KEY ): emit_signal("unflagged", FlagTypes.KEY);
				if(playNode.hasFlagsRemaining(FlagTypes.KEY)):
					if (tile.getFlag() != FlagTypes.KEY ): emit_signal("flagged", FlagTypes.KEY);
					if (tile.getFlag() == FlagTypes.ENEMY): emit_signal("unflagged", FlagTypes.ENEMY);
					tile.flagTile(FlagTypes.KEY);

			ActionTypes.ESCAPE:
				pass

func floodFill(id, isStartingTile):
	if ((id>= 0) and (id<dataArray.size())):
		var l_tile:Control = grid.get_child(id);
		#print("tile type", l_tile.getTileType(), l_tile.getTileType() <= 0, l_tile.isCovered())
		
#		and l_tile.isMarked()
		if (isStartingTile) or (!l_tile.isMarked() and l_tile.getTileType() <= 0 and l_tile.isCovered()):
			#print("flipping ", id, ", ", l_tile.isMarked())
			grid.get_child(id).flip();
			if (!isOutBoundsHoriz(id,-1)): floodFill(id-1, false);
			if (!isOutBoundsHoriz(id, 1)): floodFill(id+1, false);
			if (!isOutOfBoundsVert(id,-1)): floodFill(id-yHeight, false);
			if (!isOutOfBoundsVert(id, 1)): floodFill(id+yHeight, false);
		elif (!l_tile.isMarked() and l_tile.getTileType() <= 1 and l_tile.isCovered()):
			grid.get_child(id).flip();


func registerTiles():
	print("registering tiles")
	var i = 0;
	for tile in grid.get_children():
		tile.tileClicked.connect( tileClicked );
		tile.setId(i);
		tile.setLowerBounds(lowerBounds);
		i+=1;


func _on_stall_start_timeout() -> void:
	print("ready to play!!");
	readyToPlay = true;
	pass # Replace with function body.
