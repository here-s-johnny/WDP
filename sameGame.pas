program sameGame;

const maxK = 20;
      maxW = 26;

type Board = array [1..maxK,1..maxW] of Char;

var  k,w,g: Integer;
     x, score : Longint; 
     s1,s2 : String;
     A : Board;
     moveAvail: Boolean;

procedure generatePseudorandom(var x : Longint);
   
  const M = MAXLONGINT;
        A = 7 * 7 * 7 * 7 * 7;
        Q = M div A;
        R = M mod A;
  
  begin
	  assert(M = 2147483647);
    assert(A = 16807);
    assert(R < Q);
    x := A * (x mod Q) - R * (x div Q);
    if x < 0 then x := x + M;
  end;

procedure getData;

// this procedure gets the data from the input stream and stores them in variables for further use 

  begin
    read(k);
    read(w);
    read(x);
    readln(g);
    readln(s1);
    readln(s2);
  end;

procedure fillBoard(var A : Board; s1,s2 : String; var x : Longint);

// this procedure fills the game board according to the given algorithm

  var s : String;
      i,j: Integer;
      xi : Longint;

  begin
    s := s1 + s2;
    for i := 1 to k do begin
      for j := 1 to w do begin
        generatePseudorandom(x);
        xi := x;
        A[j,i] := s[1 + xi mod length(s)];  
      end;
    end;
  end;

function removeGroup(var A : Board; i,j : Integer): Integer;

  var counter : Integer;
      c : Char;

  procedure remove(var A : Board; i,j : Integer);
   
  // recursive sub-procedure which finds and removes all blocks of the given type

    begin
      if (i <= k) and (i >= 1) and (j >= 1) and (j <= w) then begin
        if A[j,i] = c then begin
          A[j,i] := ' ';
          inc(counter);
          remove(A,i+1,j);
          remove(A,i-1,j);
          remove(A,i,j+1);
          remove(A,i,j-1);
        end;
      end;
    end; // remove

    begin
      c := A[j,i];
      counter := 0;
      remove(A,i,j);
      if counter = 1 then A[j,i] := c;
      removeGroup := counter;
    end;

procedure drawBoard(const A : Board);

  var i,j : Integer;
      c : Char;

  begin
    write('  +');
    for i := 1 to 2 * k + 1 do write('-');
    writeln('+');
    for i := w downto 1 do begin
      write(i mod 10, ' |');
      for j := 1 to k do write(' ',A[i,j]);
      writeln(' |');
    end;
    write('  +');
    for i := 1 to 2 * k + 1 do write('-');
    writeln('+');
    write('    ');
    i := 2;
    write('a');
    for c := 'b' to 'z' do begin
      if i <= k then begin 
        write(' ', c);
        inc(i);
      end;
    end;
    writeln;
  end;

procedure cleanBoard(var A : Board);

// procedure that cleans the game board in two phases, using "two-dimensional gravity"

  var i,j,l : Integer;
      empty : Boolean;

  function emptyColumn(const A : Board; i : Integer): Boolean;

    var j : Integer;

    begin 
      empty := true;
      for j := 1 to w do
        if A[j,i] <> ' ' then empty := false;
      emptyColumn := empty;
    end; // emptyColumn 

  begin
    for i := 1 to k do begin
      for j := 1 to w do begin
        if A[j,i] = ' ' then begin
          l := j + 1;
          while (l <= w) and (A[l,i] = ' ') do inc(l);
          if l <= w then begin
            A[j,i] := A[l,i];
            A[l,i] := ' ';
          end;
        end;
      end;
    end; // phase 1

    for i := 1 to k do begin
      if emptyColumn(A,i) then begin
        l := i + 1;
        while (l <= k) and (emptyColumn(A,l)) do inc(l);
          if l <= k then begin
            for j := 1 to w do begin
              A[j,i] := A[j,l];
              A[j,l] := ' ';
            end;
          end;
      end;
    end; // phase 2

  end;

procedure computerMove(var A : Board; s : String);

// procedure that describes the AI of the computer-player

  var B : array [1..maxK,1..maxW] of Boolean;
      biggestI,biggestJ,currentI,currentJ, counter, biggestCount,i,j: Integer;
      first : Boolean;
      c : Char;

  procedure move(i,j : Integer; c : Char);
  
  // recursive subprocedure which searches for the biggest group that the computer-player is
  // allowed to remove; it uses another board B to enter each block once only

  begin
    if (i <= k) and (i >= 1) and (j >= 1) and (j <= w) and (A[j,i] = c) then begin
      if first then begin
        first := false;
        currentI := i;
        currentJ := j;
      end;
      if not B[j,i] then begin
        B[j,i] := true;
        inc(counter);
        move(i+1,j,c);
        move(i-1,j,c);
        move(i,j+1,c);
        move(i,j-1,c);
      end;
    end;
  end; // move

  begin
    biggestCount := 0;
    biggestI := 0;
    biggestJ := 0;
    for i := 1 to k do
      for j := 1 to w do 
        B[j,i] := false;
    for c in s do begin
      for i := 1 to k do
        for j := 1 to w do begin
          counter := 0;
          first := true;
          move(i,j,c);
          if (counter > biggestCount) or ((counter = biggestCount) and (currentI < biggestI))
          or ((counter = biggestCount) and (currentI = biggestI) and (currentJ < biggestJ)) then begin
            biggestCount := counter;
            biggestI := currentI;
            biggestJ := currentJ;
          end; 
        end;
      end;
    if biggestCount > 1 then begin
      removeGroup(A,biggestI,biggestJ);
      i := 1;
      c := 'a';
      while i < biggestI do begin
        inc(c);
        inc(i);
      end;
      writeln('(', c, biggestJ, ')');
      score := score - ((biggestCount - 1) * (biggestCount - 1));
      writeln('wynik: ', score);
    end else moveAvail := false;
  end;

procedure playerMove(var A : Board; s : String);

// this procedure conducts the move of the player - if possible - after getting the coordinates
// from the input stream

  var i,j,k,n : Integer;
      c,d : Char;
      avail : Boolean;

  begin
    repeat
      read(c);
      readln(j);
      i := 0;
      for d := 'a' to c do inc(i);
      avail := false;
      for k := 1 to length(s) do
        if (s[k] = A[j,i]) and (not avail) then
          avail := true;
      if avail then
        n := removeGroup(a,i,j);
        if n = 1 then 
          avail := false
     until avail;
      score := score + ((n - 1) * (n - 1));
      writeln('wynik: ', score);

  end;

begin

  //the main code which simulates the game depending on who the first player is

  getData;
  moveAvail := true;
  score := 0;
  fillBoard(A,s1,s2,x);
  drawBoard(A);
  if g = 1 then begin
    while (not eof) and (moveAvail) do begin
      playerMove(A,s1);
      cleanBoard(A);
      drawBoard(A);
      computerMove(A,s2);
      if moveAvail then begin
        cleanBoard(A);
        drawBoard(A);
      end;
    end;
  end else begin
    while (not eof) and (moveAvail) do begin
      computerMove(A,s1);
      cleanBoard(A);
      drawBoard(A);
      playerMove(A,s2);
      cleanBoard(A);
      drawBoard(A);
    end;
    if eof then begin 
      computerMove(A,s1);
      cleanBoard(A);
      drawBoard(A);
    end;
  end;
end.
