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

var L : bigList; 

procedure initBigList(L : bigList);

  var pom : bigList;

  begin
    new(pom);
    pom^.next := l;
    pom^.y := 0;
    pom^.l := nil;
    pom^.last := pom;
    L := pom;
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
      new(pom);
      pom^.next := nil;
      pom^.y := z;
      pom^.l := nil;
      L^.last^.next := pom;
      L^.last := pom;
    end;
  end;  

procedure addToList(var l : list; o :integer; z : integer);

  var pom : list;

  begin
    if o = 0 then begin
      pom := l;
      new(l);
      l^.next := pom;
      l^.last := pom^.last;
      l^.x := z;
      l^.c := ' ';
    end else if o = 1 then begin
      new(pom);
      pom^.next := nil;
      pom^.x := z;
      pom^.c := ' ';
      l^.last^.next := pom;
      l^.last := pom;
    end else begin
      new(l);
      l^.next := nil;
      l^.last := l;
      l^.x := z;
      l^.c := '#';
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

procedure getLine(var startX, startY, length, width : integer);

  begin
    while not eoln do begin
      read(startX);
      read(startY)
 

begin

new(L);
initbigList(L);
addToList(L^.l,2,0);
addToList(L^.l,1,1);
addToList(L^.l,1,2);
addToList(L^.l,0,3);

printStructure(L);
end.


