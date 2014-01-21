program rectangles;

type bigList = ^elemOfBigList;
     list = ^elemOfList;
     elemOfBigList = record
       l : list;
       y : integer;
       next : bigList;
       last : bigList;
     end;
     elemOfList = record
       c : char;
       x : integer;
       next : list;
       last : list;
    end; 

var L,K : bigList; 
    startX,startY,length,width,i : integer;

procedure initBigList(L : bigList);
 
  begin
    L^.next := nil;
    L^.y := 0;
    L^.l := nil;
  end;

procedure addToBigList(var L : bigList; o : integer; z : integer);

  var pom : bigList;

  begin
    if o = 0 then begin
      pom := L;
      new(L);
      L^.next := pom;
      L^.last := pom^.last;
      L^.y := z;
      L^.l := nil;
    end else begin
      while L^.next <> nil do L := L^.next;
      new(pom);
      pom^.next := nil;
      pom^.y := z;
      pom^.l := nil;
      L^.next := pom;
    end;
  end;  

procedure addToList(var l : list; o :integer; z : integer);

  var pom, pom2 : list;

  begin
    if o = 0 then begin
      pom := l;
      new(l);
      l^.next := pom;
      l^.x := z;
      l^.c := ' ';
    end else if o = 1 then begin
      pom2 := l;
      while l^.next <> nil do l := l^.next;
      new(pom);
      pom^.next := nil;
      pom^.x := z;
      pom^.c := ' ';
      l^.next := pom;
      l := pom2;
    end else begin
      new(l);
      l^.next := nil;
      l^.x := z;
      l^.c := ' ';
    end;  
  end;

procedure printStructure(L : bigList);

  begin
    while L <> nil do begin
      while L^.l <> nil do begin
        write(L^.l^.c);
        L^.l := L^.l^.next;
      end;
      writeln;
      L := L^.next;
    end;
  end;   

procedure getLine(var startX, startY, length, width : integer; first : boolean);

  begin
    if not eoln then begin
      if first then begin
        while not eoln do begin
          startX := 0;
          startY := 0;
          read(length);
          read(width);
        end;
      end else begin
        while not eoln do begin
          read(startX);
          read(startY);
          read(length);
          read(width);
        end;
      end;
      readln;
    end;
  end;
    
procedure goToStartPoint(var L : bigList; var K : bigList; y,width: integer);

  var i,j : integer;  
      pom : bigList;
  begin
    pom := L;
    if y < L^.y then begin
      for i := L^.y -1 downto y do 
        addToBigList(L,0,i);
      K := L;
      j := L^.y;
      while L^.next <> nil do L := L^.next;
      for i := L^.y + 1 to y + width - L^.y - j do addToBigList(L,1,i);
      L := K;
    end else if y > L^.y then begin
      j := L^.y;
      while L^.next <> nil do L := L^.next;
      for i := L^.y + 1 to y + width - L^.y - j do addToBigList(L,1,i);
      K := L;
      j := L^.y;
      while L^.next <> nil do L := L^.next;
      for i:= L^.y + 1 to y + width - L^.y - j do addToBigList(L,1,i);
      L := pom;
    end else begin
      K := L;
      j := L^.y;
      while L^.next <> nil do L := L^.next;
      for i:= L^.y + 1 to y + width - L^.y - j do addToBigList(L,1,i);
      L := pom;
    end;
  end;

procedure expandList(L : bigList; x,length : integer);

  var i : integer;

  begin
    while L <> nil do begin
      if L^.l = nil then begin 
        addToList(L^.l,2,0);
        for i := x+1 to x+length-1 do addToList(L^.l,1,i); 
      end else if L^.l^.x > x then begin
        if length-abs(x) > 0 then
          for i := L^.l^.x + 1 to length-abs(x) do addToList(L^.l,1,i);
        for i := L^.l^.x -1 downto x do addToList(L^.l,0,i)
      end else if L^.l^.x < x then begin
        while L^.l^.x < x do begin
          if L^.l^.next = nil then addToList(L^.l,1,L^.l^.x +1) 
          else L^.l := L^.l^.next;
        end;
        for i := x+1 to length do addToList(L^.l,1,i);
      end else 
        for i := x+1 to length do addToList(L^.l,1,i);
      L := L^.next;
    end;
  end;   

procedure hash(K : bigList; x,length : integer);
 
  var i : integer;

  begin
    while K^.l^.x < x do K^.l := K^.l^.next;
    for i := x to length -1 do begin
      writeln(K^.y);
      writeln(i);
      K^.l^.c := '#';
      writeln(K^.l^.c);
      K^.l := K^.l^.next;
    end;
    //K^.l^.c := '#';
  end;


begin

new(L);
initBigList(L);
new(K);

{writeln(L^.l^.c, L^.l^.x);
addToList(L^.l,0,-1);
addToList(L^.l,1,1);
addToList(L^.l,0,-2);
while L^.l <> nil do begin
  writeln(L^.l^.c, L^.l^.x);
  L^.l := L^.l^.next;
end;}

  getLine(startX,startY,length,width,true);
    goToStartPoint(L,K,startY,width);
    expandList(L,startX,length);
    for i := 1 to width do begin
      hash(K,startX,length);  
      K := K^.next;
    end;
 while L <> nil do begin
   writeln(L^.l^.c);
   L := L^.next;
end;
  {while not eoln do begin    
    getLine(startX,startY,length,width,false);
    writeln(startX);
    writeln(startY);
    writeln(length);
    writeln(width);
    goToStartPoint(L,K,startY,width);
    expandList(L,startX,length);
    hash(K,startX,length);  
end;}
//printStructure(L);
end.


