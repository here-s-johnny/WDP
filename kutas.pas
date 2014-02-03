program rectangles;

type
   location = (beginning, the_end, initialize);
   bigList = ^elemOfBigList;
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

procedure initBigList(var L : bigList);
  begin
    new(L);
    L^.next := nil;
    L^.last := L;
    L^.y := 0;
    L^.l := nil;
  end;
 
function initList(): list;
  var
	  l : list;
  begin
    new(l);
    L^.next := nil;
    L^.last := L;
    L^.y := 0;
  end;



procedure addToBigList(var L : bigList; where : location; y : integer);
  var
    pom : bigList;
  begin
    if where = beginning then begin
      pom := L;
      new(L);
      L^.next := pom;
      L^.last := pom^.last;
      L^.y := y;
      L^.l := nil;
    end else begin // adding to the end
      new(pom);
      pom^.next := nil;
      pom^.y := y;
      pom^.l := nil;
      pom^.last := pom;
      L^.last^.next := pom;
      L^.last := pom;
    end;
  end;  

procedure addToList(var l : list; where : location; x : integer);
  var
    pom : list;
  begin
    if where = beginning then begin
      pom := l;
      new(l);
      l^.next := pom;
      l^.x := x;
      l^.last := pom^.last;
      l^.c := ' ';
    end else if where = the_end then begin
      new(pom);
      pom^.next := nil;
      pom^.x := x;
      pom^.c := ' ';
      L^.last^.next := pom;
      L^.last := pom;
    end else begin // initializing
      new(l);
      l^.next := nil;
      l^.x := x;
      l^.last := l;
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

procedure getLine(var startX, startY, length, width : integer; var first : boolean);
  begin
    if not eoln then begin
      if first then begin
        while not eoln do begin
          startX := 0;
          startY := 0;
          read(length);
          read(width);
        end;
        first := false;
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
  var i : integer;  
      pom : bigList;
  begin
    pom := L;
    if y < L^.y then begin
      for i := L^.y -1 downto y do 
        addToBigList(L,beginning,i);
      K := L;
      L := L^.last;
      for i := L^.y + 1 to width + y do addToBigList(L,the_end,i);
      L := K;
    end else begin
      while y < L^.y do 
        if L^.next <> nil then
          L := L^.next
        else begin
         addToBigList(L,the_end,L^.y+1);
         L := L^.last;
       end;
     K := L;
     for i := L^.y+1 to L^.y + width do 
        if L^.next <> nil then
          L := L^.next
        else begin
         addToBigList(L,the_end,i);
         L := L^.last;
       end;
     L := pom;
   end;
 end;

procedure writeList(L : bigList);
  begin
    writeln('xxx');
    while L <> NIl do begin
      write(L^.y, ' ');
      L := L^.next;
    end;
    writeln();
  end;

var
  K,L : bigList;
  a,b,c,d : integer;
  f : boolean;

begin
  f := true;
  initBigList(L);
  while true do begin
    getLine(a,b,c,d,f);
    goToStartPoint(L, K , a, c );
    writeList(L);
  end;
end.


//  procedure expandList(L : bigList; x,length : integer);
//  
//    var i : integer;
//  
//    begin
//      while L <> nil do begin
//        if L^.l = nil then begin 
//          addToList(L^.l,2,0);
//          for i := x+1 to x+length-1 do addToList(L^.l,1,i); 
//        end else if L^.l^.x > x then begin
//          if length-abs(x) > 0 then
//            for i := L^.l^.x + 1 to length-abs(x) do addToList(L^.l,1,i);
//          for i := L^.l^.x -1 downto x do addToList(L^.l,0,i)
//        end else if L^.l^.x < x then begin
//          while L^.l^.x < x do begin
//            if L^.l^.next = nil then addToList(L^.l,1,L^.l^.x +1) 
//            else L^.l := L^.l^.next;
//          end;
//          for i := x+1 to length do addToList(L^.l,1,i);
//        end else 
//          for i := x+1 to length do addToList(L^.l,1,i);
//        L := L^.next;
//      end;
//    end;   
//  
//  procedure hash(K : bigList; x,length : integer);
//   
//    var i : integer;
//  
//    begin
//      while K^.l^.x < x do K^.l := K^.l^.next;
//      for i := x to length -1 do begin
//        writeln(K^.y);
//        writeln(i);
//        K^.l^.c := '#';
//        writeln(K^.l^.c);
//        K^.l := K^.l^.next;
//      end;
//      //K^.l^.c := '#';
//    end;
//  
//  
//  var L,K : bigList; 
//      startX,startY,length,width,i : integer;
//  
//  begin
//  
//  
//  {writeln(L^.l^.c, L^.l^.x);
//  addToList(L^.l,0,-1);
//  addToList(L^.l,1,1);
//  addToList(L^.l,0,-2);
//  while L^.l <> nil do begin
//    writeln(L^.l^.c, L^.l^.x);
//    L^.l := L^.l^.next;
//  end;}
//  
//    getLine(startX,startY,length,width,true);
//      goToStartPoint(L,K,startY,width);
//      expandList(L,startX,length);
//      for i := 1 to width do begin
//        hash(K,startX,length);  
//        K := K^.next;
//      end;
//   while L <> nil do begin
//     writeln(L^.l^.c);
//     L := L^.next;
//  end;
//    {while not eoln do begin    
//      getLine(startX,startY,length,width,false);
//      writeln(startX);
//      writeln(startY);
//      writeln(length);
//      writeln(width);
//      goToStartPoint(L,K,startY,width);
//      expandList(L,startX,length);
//      hash(K,startX,length);  
//  end;}
//  //printStructure(L);
//  end.
