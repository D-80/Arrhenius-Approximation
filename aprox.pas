program matma; 
uses crt, math, sysutils; 


(*Program transformujacy zaleznosc pomiedzy szybkoscia reakcji a temperatura do postaci liniowej i wyswietlajacy wykres*)

const
e : real = 2.71828;

var 
A, b: real; (*A = pre-exponential factor, b = activation energy*)
datarr : array [0..20, 0..20] of real;  
approxarr : array [0..20] of real;  

procedure getData(); 

	var	

	data : textfile;
	entry : string; 
	entryref : real; 
	i : integer = 0;
	j : integer = 0;
	code : integer;
	
	begin

	assign(data, 'data.txt'); 	
	reset(data);

	while i < 11 do

		begin

		readln(data, entry);
		
		if (i <> 0) then 
		
			begin 
			datarr[0,j] := i * 100; 
			val(entry,entryref,code);  
			datarr[1,j] := entryref;
			inc(j,1);  
			end;	

		inc(i,1);

		end;

	if (i <> 20) then
	
		begin 
		datarr[0,j] := i * 100; 
		inc(j,1); 
		inc(i,1);  
		end;	

	end; 


procedure showData(); 

	var

	i : integer = 0;

	begin

	writeln; 
	writeln('T[K]/k');

	while i < 10 do 
	
		begin
		write(datarr[0,i]:1:0); (*temperature K*) 
		write(' = ');
		writeln(datarr[1,i]:1:5); (*k value*)
		inc(i,1); 
		end;
	writeln; 

	end;

procedure setConstants(modA, modb : real); (*constant modifiers for manual calibration*) 

	(* Arrhenius Eq. "k = Ae^(-b/T)" *)
	(* 1. A is a limit, so we can assume it's something close to the highest value of k *) 
	(* 2. "ln K = ln A - b/T" to make things easier*) 

	var
	k, T : real; 	(*k = rate constant, T = absolute temperature*)
	barr : array[0..10] of real;
	kvalues : array[0..10] of real; 
	i : integer = 0; 	
	sumvar : real = 0; 	

	begin 

	while i < 10 do 

		begin
		kvalues[i] := datarr[1,i]; 
		inc(i,1); 
		end;	

	A := maxvalue(kvalues) + modA; (*getting A*)	

	i := 0; 

	while i < 10 do 

		begin	
		T := datarr[0,i]; 
		k := datarr[1,i]; 
		barr[i] := (ln(A) - ln(k)) * T ; (*getting diff val of b*)
		inc(i,1); 
		end;	

	i := 0; 

	while i < 10 do 

		begin
		sumvar := sumvar + barr[i];
		inc(i,1); 
		end;

	sumvar := sumvar / 10; 

	b := sumvar + modb; (*getting b*)		 

	end; 


procedure getApproxData();

	var
	T, expon : real; 
	i : integer = 0; 

	begin

	while i < 10 do

		begin 

		T := datarr[0,i]; 
		
		expon := -(b)/T; 

		approxarr[i] := (A) * power(e,expon);
	
		inc(i,1); 

		end;
	end; 	


procedure showApproxData(); 

	var

	i : integer = 0;

	begin

	writeln;
	writeln('T[K]/k');

	while i < 10 do 
	
		begin
		write(datarr[0,i]:1:0); (*temperature K*) 
		write(' = ');
		writeln(approxarr[i]:1:5); (*k value*)
		inc(i,1); 
		end;
	writeln; 

	end;



(*MAIN*)

begin 

	writeln; 

	writeln('Zaleznosc stalej szybkosci reakcji od temperatury:');

	getData();

	showData(); 

	setConstants(4,-7); 

	getApproxData();

	writeln('Wartosci zmiennych:'); 
	writeln(); 

	writeln('b = ', b:1:4);
	writeln('A = ', A:1:4); 

	writeln();
	writeln('Po dokonaniu aproksymacji:'); 

	showApproxData();  

end.  
