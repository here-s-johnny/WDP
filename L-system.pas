program LSystem;

const firstASCII = chr(0);		{pierwszy i ostatni "rozsadny" znak w tablicy ASCII} 
      lastASCII = chr(127);

type AsciiArray = array[firstASCII..lastASCII] of string;

var i : char;
    A : AsciiArray;
    axiom : ansistring;
    repeats,j : longint;

procedure description(var A : AsciiArray);  {ta procedura wypelnia tablice regułami opisu L-systemu a w drugim wywolaniu regułami interpretacji}
  var s : string;
      enter : boolean;
  begin 
    enter := false;
    while (not enter) do begin
      readln(s);
      if length(s) <> 0 then A[s[1]] := s
      else enter := true;
    end;
  end;

procedure translate(var A : ASCIIArray; var axiom : ansistring);  {ta procedura zmienia podany aksjomat według reguł opisanych procedura description tworząc nowy aksjomat}  
  var i,j : longint;  
      newAxiom, word : ansistring;
  begin
    newAxiom := '';  
    word := '';
    for i := 1 to length(axiom) do begin
      word := A[axiom[i]];
      for j := 2 to length(word) do begin
        newAxiom := newAxiom + word[j]
      end;
    end;
    axiom := newAxiom;
  end;

procedure copyPaste;  {ta procedura wypisuje bez zmian blok kodu do pustego wiersza}
  var s : string;
      enter : boolean;
  begin
    enter := false;
    while (not enter) do begin
      readln(s);
      if length(s) <> 0 then writeln(s)
      else enter := true;
    end;
  end;

procedure interpret(var A :ASCIIArray; var axiom : ansistring);  {t procedura interpretuje według reguł przekazanych przez procedure description aksjomat i wypisuje wyjsciowe dane}
  var i,j : longint;
      newAxiom, word : ansistring;
  begin
    word := '';
    for i := 1 to length(axiom) do begin
      word := A[axiom[i]];
      newAxiom := '';
      for j := 2 to length(word) do begin
        newAxiom := newAxiom + word[j];
      end;
      if length(word) > 0 then
        writeln(newAxiom);
    end;
  end;

begin
  for i := firstASCII to lastASCII do
    A[i] := i+i;
  readln(repeats);
  readln(axiom);
  description(A);
  for j := 1 to repeats do
    translate(A,axiom);
  copyPaste;
  for i :=firstASCII to lastASCII do
    A[i] := '';
  description(A);
  interpret(A,axiom); 
  copyPaste;
end. 
