program BFS;

const n = 10;

type colors = (bialy, szary, czarny);

type nodes = ^joint;
  
     joint = record
       n : integer;
       next : nodes;
     end;

type tab = array [1..n] of nodes; 
    
type kolejka = ^listaK;
    
     lista = ^elemListy;

     elemListy = record
       n : integer;
       next : lista;
     end;

     listaK = record
       n : integer;
       first,last : lista;
     end;

var A : tab;
    amount,i : integer;
    kolory : array [1..n] of colors;
    d, P : array [1..n] of integer;
    k : kolejka;
 
///////////////////////// obsluga kolejki ///////////////////////////////////

procedure initKolejka(var k : kolejka);
  
  begin
    new(k);
    k^.first := nil;
    k^.last := k^.first;
  end;

procedure wstawZa(var l : lista; n : integer);
  
  var pom : lista;

  begin
    new(pom);
    pom^.next := l^.next;
    pom^.n := n;
    l^.next := pom;
  end;

procedure wstawDoKolejki(var k : kolejka; var n : integer);
  
  begin
    if k^.first = nil then begin
      new(k^.first);
      k^.first^.n := n;
      k^.first^.next := nil;
      k^.last := k^.first;
    end else begin
      wstawZa(k^.last,n);
      k^.last := k^.last^.next;
    end;
  end;

procedure pobierz(k : kolejka; var n : integer);

  begin
    n := k^.first^.n;
  end;

procedure usun(var k : kolejka);
  
  var pom : lista;
   
  begin
    pom := k^.first;
    if k^.first = k^.last then k^.first := nil
    else k^.first := k^.first^.next;
    dispose(pom);
  end;
  
function pusta(k : kolejka): boolean;

  begin
    pusta := k^.first = nil;
  end;

///////////////////////// obsluga grafu ///////////////////////////////////////

procedure initTab(var A : tab);

  var i : integer; 
  
  begin
    for i := 1 to n do A[i] := nil;
  end;

procedure addToList(var l : nodes; var n : integer);

  var pom : nodes;
  
  begin
    new(pom);
    pom^.n := n;
    pom^.next := l;
    l := pom;
  end;

procedure addNodes(var A : tab; var amount : integer);
  
  var i,n : integer;

  begin 
    for i := 1 to amount do begin
      while not eoln do begin
        read(n);
        addToList(A[i],n);
      end;
      readln;
    end;
  end; 

//////////////// BFS(A,s) (wyjscie: d[v] - najkrotsza droga z s do v; P[v] - poprzednik na najkrotszej drodze z s do v)  /////////////////////////////////////

procedure BFS(var A : tab; var k : kolejka; var s : integer; var amount : integer);

  var v,u : integer;

  begin
    for v := 1 to amount do begin
      P[v] := 0;
      d[v] := -1;
      kolory[v] := bialy;
    end;
    d[s] := 0;
    kolory[s] := szary;
    wstawDoKolejki(k,s);
    while not pusta(k) do begin
      pobierz(k,u);
      while A[u] <> nil do begin
        v := A[u]^.n;
        if kolory[v] = bialy then begin
          d[v] := d[u] + 1;
          P[v] := u;
          kolory[v] := szary;
          wstawDoKolejki(k,v);
        end;
        usun(k);
        kolory[u] := czarny;
        A[u] := A[u]^.next;
      end;
    end;
  end;

begin
  initTab(A);
  readln(amount);
  addNodes(A,amount);
  initKolejka(k);
  i := 2;
  BFS(A,k,i,amount);

  for i := 1 to amount do 
    write(d[i], ' '); 
  writeln;
  for i := 1 to amount do
    write(P[i], ' ');

end. 
