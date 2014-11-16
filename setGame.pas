program setGame;

const N = 81;

type deck = array [1..N] of Integer;
     
type shape = (oval, rhombus, wave);
type colour = (red, green, purple);
type pattern = (empty, plain, striped);     
type card = record
     	 n : integer;
     	 s : shape;
     	 c : colour;
     	 p : pattern;
     end;

var d,t : deck;
    tableState, deckController : Integer;
    found : Boolean;

procedure getDeck(var d : deck);

  var i,m : Integer;

  begin
    for i := 1 to N do begin
      read(m);
      d[i] := m; 
    end;
  end;

function makeCard(x : Integer):card;
 
  var 
    c : card;
    i,j : integer;

  begin
    i := x div 10;
    j := x mod 10;
    case (i) of 
      1 : begin
      	c.n := 1;
      	c.c := red;
      end;
      2 : begin
      	c.n := 1;
      	c.c := green;
      end;
      3 : begin
      	c.n := 1;
      	c.c := purple;
      end;
      4 : begin
      	c.n := 2;
      	c.c := red;
      end;
      5 : begin
      	c.n := 2;
      	c.c := green;
      end;
      6 : begin
      	c.n := 2;
      	c.c := purple;
      end;
      7 : begin
      	c.n := 3;
      	c.c := red;
      end;    
      8 : begin
      	c.n := 3;
      	c.c := green;
      end;
      9 : begin
      	c.n := 3;
      	c.c := purple;
      end;
    end;
    case (j) of
      1 : begin
      	c.p := empty;
      	c.s := rhombus;
      end;
      2 : begin
      	c.p := empty;
      	c.s := wave;
      end;    
      3 : begin
      	c.p := empty;
      	c.s := oval;
      end;  
      4 : begin
      	c.p := striped;
      	c.s := rhombus;
      end;  
      5 : begin
      	c.p := striped;
      	c.s := wave;
      end;  
      6 : begin
      	c.p := striped;
      	c.s := oval;
      end;  
      7 : begin
      	c.p := plain;
      	c.s := rhombus;
      end;  
      8 : begin
      	c.p := plain;
      	c.s := wave;
      end;  
      9 : begin
      	c.p := plain;
      	c.s := oval;
      end;  
    end;
  makeCard := c;
  end;

function setFound(x,y,z : card):Boolean;

  var n,s,c,p : Boolean;

  begin
      n := false;
      s := false;
      c := false;
      p := false;
  	  if (x.n = y.n) then begin
    	  if (y.n = z.n) then n := true;
     	end else if (x.n <> z.n) and (y.n <> z.n) then n := true;
     	if (x.s = y.s) then begin
    	  if (y.s = z.s) then s := true;
     	end else if (x.s <> z.s) and (y.s <> z.s) then s := true;
     	if (x.c = y.c) then begin
    	  if (y.c = z.c) then c := true;
     	end else if (x.c <> z.c) and (y.c <> z.c) then c := true;
     	if (x.p = y.p) then begin
    	  if (y.p = z.p) then p := true;
     	end else if (x.p <> z.p) and (y.p <> z.p) then p := true;

  setFound := n and s and c and p;
  end;

procedure updateTable(var t : deck; var tableState, deckController : integer);

	var i,j : Integer;

  begin
    tableState := tableState + 3;
    for i := 1 to N do t[i] := 0;
    i := 1;
    j := 1;
		while (j <= tableState) do begin
			while d[i] = 0 do inc(i);
			t[j] := d[i];
      if i > deckController then deckController := i;
			inc(i);
			inc(j);
		end;
  end;

procedure tableOutput(t : deck);

  var i : Integer;  

  begin
  	i := 2;
  	write('=');
    if t[1] <> 0 then write(' ', t[1]);
  	while t[i] <> 0 do begin
  	  write(' ', t[i]);
  	  inc(i);
  	end;
  	writeln;
  end;

procedure checkForSets(var t,d : deck);

  var i,j,k,l : Integer;

  begin
    found := false;
  	for i := 1 to tableState do begin
  		for j := i + 1 to tableState do begin
  		  for k := j + 1 to tableState do begin
  		    if (not found) and (setFound(makeCard(t[i]),makeCard(t[j]),makeCard(t[k]))) then begin
  		      writeln('- ', t[i], ' ', t[j], ' ', t[k]);
  		      for l := 1 to N do
  		        if (d[l] = t[i]) or (d[l] = t[j]) or (d[l] = t[k]) then d[l] := 0;
            found := true;
            if (tableState > 12) or (deckController >= N) then tableState := tableState - 6
            else tableState := tableState - 3;
  		    end;
  		  end;
  		end;    
  	end;
  	if (not found) and (deckController < N) then writeln('-');
  	updateTable(t,tableState,deckController);
  end;


begin
	getDeck(d);
  tableState := 9;
  deckController := 1;
  updateTable(t,tableState,deckController);
  while deckController <= N do begin
  	tableOutput(t);
  	checkForSets(t,d);
  end;
  while found do begin
  	tableOutput(t);
  	checkForSets(t,d);
  end;
end.