{ File Name : appPembelian.pas }
{ Description : Menyimpan data barang yang akan diinput User lalu menampilkan harga dari barang yang dibeli }
{ Date : 6 Nov - 5 Des 2016 }

Program aplikasiPembelian;
Uses crt;

Type
	dataPembeli = record
		username : string;
		pass : integer;
	end;
	
	tabItem = array of string; //menyimpan nama item
	tabPrice = array of longint; //menyimpan harga dari setiap 'tabItem'
	tabCart = array of integer; //menyimpan nomor barang yang dibeli User
	tabAmount = array of longint; //menyimpan jumlah barang dari setiap 'tabCart'

Var
	data : dataPembeli;
	item : tabItem;
	prc : tabPrice;
	cart : tabCart;
	isi : tabAmount;
	
	input, total, menu : integer;
	
	fileCart : file of tabCart;
	fileAmount : file of tabAmount;
	fileAccount : file of dataPembeli;
	
procedure listItem(var list : tabItem);
{IS : Array tabItem belum terisi
 FS : tabItem telah diisi dengan barang-barang yang tersedia untuk dijual}

begin
	list[0] := 'Bebelac 3 Madu/Vanilla';
	list[1] := 'Tropicana Slim';
	list[2] := 'Morin Jam Peanut Butter';
	list[3] := 'Hydro Coco 250ml';
	list[4] := 'Sari Roti 200g';
	list[5] := 'Indofood Sambal Pedas 340 ml';
	list[6] := 'Entrostop Obat Diare';
	list[7] := 'Paseo Facial Tissue Pure Soft';
	list[8] := 'Baygon 600ml';
	list[9] := 'Quaker Oatmeal 200g';
	list[10]:= 'Luwak White Koffie Original 10x20 g';
	list[11]:= 'Indomilk Susu Kental Manis 375g';
	list[12]:= 'Taro Net/3D 40g';
	list[13]:= 'Dua Kelinci Kacang Sukro 140g';
	list[14]:= 'Kraft Oreo Sandwich 13g';
	list[15]:= 'Head and Shoulders Shampoo 330ml';
	list[16]:= 'Mens Biore Facial Foam 100g';
	list[17]:= 'Counterpain Obat Gosok 30g';
	list[18]:= 'Milo 240ml';
	list[19]:= 'Rinso Detergent Powder 700g';
end;

procedure listPrice(var hrg : tabPrice);
{IS : Item yang ada pada tiap array "tabItem" belum memiliki nilai harga
 FS : Setiap barang pada array memiliki nilai harga }

 begin
	hrg[0] := 123000;
	hrg[1] := 32500;
	hrg[2] := 16900;
	hrg[3] := 4800;
	hrg[4] := 12500;
	hrg[5] := 10900;
	hrg[6] := 5700;
	hrg[7] := 12900;
	hrg[8] := 28000;
	hrg[9] := 10000;
	hrg[10]:= 23900;
	hrg[11]:= 15000;
	hrg[12]:= 5000;
	hrg[13]:= 3000;
	hrg[14]:= 10000;
	hrg[15]:= 29500;
	hrg[16]:= 18900;
	hrg[17]:= 32900;
	hrg[18]:= 7500;
	hrg[19]:= 14300;
 end;

procedure showList(item : tabItem; prc : tabPrice);
 {IS : Menerima data barang dan harga dari array tabItem dan tabPrice
  FS : Menampilkan setiap barang beserta harganya kepada User}

 var
	 i : integer;

begin
	writeln;
	for i:=0 to (length(item)-1) do
	begin
		writeln(i+1,'.',item[i],' = Rp.',prc[i]);
	end;
	writeln;
end;

procedure showBeli(cart: tabCart; tot: tabAmount; item : tabItem; prc: tabPrice);
{IS : Barang yang sudah dipilih belum ditampilkan
 FS : Barang-barang yang akan dibeli telah ditampilkan}
var
	i,jumlah : integer;

begin
	jumlah := 0;
	for i:=0 to (length(cart)-2) do
	begin
		writeln(i+1, '.', item[cart[i]-1], ' ',tot[i], ' buah : Rp.',(prc[cart[i]-1] * tot[i]));
		jumlah := jumlah + tot[i];
	end;
	writeln('Total barang yang dibeli: ',jumlah);
	writeln;
end;

procedure beli(var cart : tabCart; var total : tabAmount; item : tabItem);
{IS : Menerima data barang beserta harganya
 FS : Barang yang akan dibeli user telah disimpan didalam Array tabCart dan telah ditampilkan}
var
	i, count: integer;
	stop : boolean;
begin
	stop := false;
	setlength(cart, 1);
	setlength(total, 1);
	i := 0;
	while (stop <> true)do
	begin
		write('Nomor barang: ');
		readln(cart[i]);
		if (cart[i] = 0) then
			stop := true;
		if (cart[i] > 0) and (cart[i] < length(item)+1) then
		begin
			write('Jumlah barang ', '"', item[cart[i]-1], '"', ': ');
			readln(count);
			total[i] := count;

			i := i + 1;
			setlength(cart, i+1);
			setlength(total, i+1);
		end
		else if (cart[i-1] <> 0) then
		begin
			write('Nomor barang yang anda masukkan tidak ada di dalam list,silahkan masukkan lagi: ');
			cart[i] := 0;
		end;
		count := 0;
	end;
	writeln;
end;

procedure biaya(var cart: tabCart; pc: tabPrice; jlh: tabAmount);
{IS : Menerima array yang berisikan barang-barang yang akan dibeli User
 FS : Harga dari barang yang dibeli ditampilkan}

var
	i : integer;
	harga : longint;
begin
	harga := 0;
	for i:=0 to (length(cart)-1) do
	begin
		harga := (pc[cart[i]-1] * jlh[i]) + harga;
	end;
	writeln('Harga yang harus dibayarkan adalah : Rp.',harga);
	writeln;

end;

procedure sortName(var item: tabItem; var prc: tabPrice);
{IS : Daftar Barang telah terdefinisi
 FS : Dafta Barang telah diurutkan berdasarkan abjad secara ascending}
var
	i, j, imin: integer;
	tempInt: longint;
	tempStr: string;

begin
	for i:=0 to length(item)-1 do
	begin
		imin := i;
		for j:= i+1 to length(item)-1 do
		begin
			if (item[j] < item[imin]) then
				imin := j;
		end;

		tempStr := item[i];
		item[i] := item[imin];
		item[imin] := tempStr;
		tempInt := prc[i];
		prc[i] := prc[imin];
		prc[imin] := tempInt;
	end;
end;

procedure sortPrice(var item: tabItem; var prc: tabPrice);
{IS : Daftar Barang telah terdefinisi
 FS : Daftar Barang telah diurut berdasarkan harganya secara ascending}
var
	i, j, imin: integer;
	tempInt: longint;
	tempStr: string;

begin
	for i:=0 to length(item)-1 do
	begin
		imin := i;
		for j:= i+1 to length(item)-1 do
		begin
			if (prc[j] < prc[imin]) then
				imin := j;
		end;

		tempStr := item[i];
		item[i] := item[imin];
		item[imin] := tempStr;
		tempInt := prc[i];
		prc[i] := prc[imin];
		prc[imin] := tempInt;
	end;
end;


procedure showMenu1;  //Menu ini ditampilkan pertama kali
{IS : Menu belum ditampilkan
 FS : Menu ditampilkan}

begin
        writeln('|=============MENU==============|');
	writeln('|Apa yang anda ingin lakukan:   |');
	writeln('|1.Beli                         |');
	writeln('|2.Urut berdasarkan nama barang |');
	writeln('|3.Urut berdasarkan harga barang|');
        writeln('|===============================|');
	writeln;
end;

procedure showMenu2; //Menu ini akan ditampilkan setelah User memilih barang yang akan dibeli
{IS : User telah menginput barang yang akan dibeli
 FS : Menu ditampilkan}

 begin
        writeln('|===========Menu==============|');
        writeln('|Apa yang anda ingin lakukan: |');
	writeln('|1.Edit keranjang belanja     |');
	writeln('|2.Delete keranjang belanja   |');
	writeln('|3.Tambah barang belanja      |');
	writeln('|4.Kembali                    |');
	writeln('|5.Selesai Belanja            |');
        writeln('|=============================|');
	writeln;
 end;

procedure stepBeli;
{IS : User belum memilih barang
 FS : User telah memilih barang yang ingin dibeli}
begin
	showList(item, prc);
	writeln('Silahkan masukkan nomor barang yang ingin dibeli');
	writeln('(Ketik "0" pada "Nomor Barang" jika sudah selesai memilih): ');
	writeln;
	beli(cart, isi, item);
	clrscr;
	showBeli(cart, isi, item, prc);
	biaya(cart, prc, isi);
	writeln;
end;

procedure edit(var cart: tabCart; var prc: tabPrice; var jlh: tabAmount; item: tabItem);  //fungsionalitas program dengan fasilitas 'Edit Data'
{IS : User telah mengisi keranjang belanja
 FS : Barang belanja sudah di edit}
var
	iChg, chg, jlhchg : integer;
begin
	write('Pilih nomor barang yang akan diganti: ');
	readln(iChg);
	while (iChg < 1) or (iChg > length(cart)-1) do  //perulangan dibuat untuk menghindari User meng-input nomor barang yang tidak ada di Keranjang Belanja
	begin
		write('Pilih nomor barang yang akan diganti: ');
		readln(iChg);
	end;
	write('Pilih nomor barang yang anda inginkan: ');
	readln(chg);
	while (Chg < 1) or (Chg > length(item)) do  //perulangan dibuat untuk menghindari User meng-input nomor barang yang tidak ada di Daftar Barang
	begin
		write('Pilih nomor barang yang anda inginkan: ');
		readln(Chg);
	end;
	write('Jumlah ',item[chg-1],' : ');
	readln(jlhchg);

	iChg := iChg - 1;
	cart[iChg] := chg;
	prc[cart[iChg]] := prc[chg];
	jlh[iChg] := jlhchg;
	writeln;
end;

procedure delete(var cart: tabCart; var prc: tabPrice; var jlh: tabAmount);  //fungsionalitas program dengan fasilitas 'Delete Data'
{IS : User telah mengisi keranjang belanja
 FS : Barang yang tida diinginkan User telah dihapus}

var
	del, i: integer;

begin
	write('Pilih nomor barang yang akan dihapus: ');
	readln(del);
	del := del - 1;
	if (del = length(cart)-1) then  //jika user memilih cart terakhir
		setlength(cart, length(cart)-1)
	else							// jika user memilih cart sebelum nomor terakhir
		for i:=del to (length(cart)-2) do
		begin
			cart[i] := cart[i+1]
		end;
		setlength(cart, length(cart)-1);

	if (del = length(cart)-1) then  //jika user memilih cart terakhir
		setlength(jlh, length(cart)-1)
	else							// jika user memilih cart sebelum nomor terakhir
		for i:=del to (length(cart)-2) do
		begin
			jlh[i] := jlh[i+1]
		end;
		setlength(jlh, length(cart)-1);
	writeln;
end;

procedure add(var cart: tabCart; var prc: tabPrice; var jlh: tabAmount; item: tabItem);  //fungsionalitas program dengan fasilitas 'Insert Data'
{IS : User telah mengisi keranjang belanja
 FS : Barang yang dibeli User telah ditambah di keranjang belanja}

var
	add, n: integer;

begin
	write('Pilih nomor barang yang diinginkan: ');
	readln(add);
	setlength(cart, length(cart)+1);
	setlength(jlh, length(cart)+1);
	write('Jumlah ', item[add-1], ' : ');
	readln(n);
	cart[length(cart)-2] := add;
	jlh[length(cart)-2] := n;
	writeln;
end;

Begin //PROGRAM UTAMA
	clrscr;
        writeln('|============================================|');
        writeln('|Selamat datang di Aplikasi Pembelian(BETA)  |');
	writeln('|Silahkan masukkan username dan password anda|');
	writeln('|============================================|');
	write('Username : ');
	readln(data.username);
	write('Password(angka 6 digit) : ');
	readln(data.pass);
	writeln;
	writeln('Selamat datang ',data.Username);
	writeln('Press any key to continue');
	readln;
	clrscr;

	{Pengisian Data Pribadi User selesai}

	setlength(item, 20);
	setlength(prc, 20);
	listItem(item);
	listPrice(prc);

	menu := 4;  //agar perulangan berjalan maka persyaratan looping harus bernilai True
	while (menu = 4) do
	begin
		clrscr;
		writeln('Daftar Barang :');
		showList(item, prc);
		writeln;
		showMenu1;
		write('Pilihan: ');
		readln(menu);

		while (menu < 1) or (menu > 3) do //perulangan ini digunakan untuk menghindari User menginput angka selain yang tersedia pada menu
		begin
			clrscr;
			showList(item, prc);
			writeln;
			showMenu1;
			write('Pilihan: ');
			readln(menu);
		end;

		case menu of
			1 : begin
				clrscr;
				writeln('Daftar Barang: ');
				stepBeli;
				end;

			2 : begin
				clrscr;
				writeln('Daftar Barang Berdasarkan Nama Barang(Ascending)');
				sortName(item, prc);
				stepBeli;
				end;

			3 : begin
				clrscr;
				writeln('Daftar Barang berdasarkan Harga(Ascending)');
				sortPrice(item, prc);
				stepBeli;
				end;

		end;
		showMenu2;
		write('Pilihan: ');
		readln(menu);
		
		while (menu <> 5) and (menu <> 4) do
		begin
			case menu of
				1 : begin  // Nomor menu 'Edit'
						clrscr;				
						writeln('Daftar Barang: ');
						showList(item, prc);
						writeln('Keranjang Belanja: ');
						showBeli(cart, isi, item, prc);
						edit(cart, prc, isi, item);					
					end;
				
				2 : begin  // Nomor menu 'Delete'
						clrscr;	
						writeln('Daftar Barang: ');
						showList(item, prc);
						writeln('Keranjang Belanja: ');
						showBeli(cart, isi, item, prc);
						delete(cart, prc, isi);	
					end;
					
				3 : begin // Nomor menu 'Tambah keranjang belanja'
						clrscr;	
						writeln('Daftar Barang: ');
						showList(item, prc);
						writeln('Keranjang Belanja: ');
						showBeli(cart, isi, item, prc);
						add(cart, prc, isi, item);
					end;
			end;
			clrscr;
			showBeli(cart, isi, item, prc);
			biaya(cart, prc, isi);
			showMenu2;
			write('Pilihan: ');
			readln(menu);
		end;
	end;
	
	writeln;
	writeln('Terima kasih atas pembeliannya, silahkan datang kembali :)');
	readln;
End.	

