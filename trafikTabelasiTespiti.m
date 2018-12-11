function [] = trafikLevhaTespiti(Goruntu) % Ana Fonksiyon
 OrjinalGoruntu = imread(Goruntu); % Orjinal Resmi oku

HsvCevir= rgb2ntsc(OrjinalGoruntu); % RGB renk uzay�ndan NTSC renk uzay�na d�n���m yap�l�yor

HsvDegeri = HsvCevir(:,:,3); % HSV -&gt; 3. parametre yani value (brighness veya parlakl�k) kullan�l�yor
 
KaliteDegeri = filter2(fspecial('average', 2), HsvDegeri); % filtre kullan�larak kalite artt�r�l�yor
 
GUHG = im2bw(10*KaliteDegeri,0.2); % G�r�nt� siyah-beyaz hale getiriliyor ve beyazl�klar�n belirginli�i artt�r�l�yor // gorunt�y� uygun hale getir
figure,imshow(GUHG);
GUHG = bwareaopen(GUHG, 30); % K���k objeler temizleniyor
GUHG = imdilate(GUHG, strel('disk',4)); % Dilation morfolojik i�lemi uygulan�yor
figure,imshow(GUHG);
GUHG = imdilate(GUHG,strel('disk',1)); % Dilation morfolojik i�lemi uygulan�yor
figure,imshow(GUHG);
GUHG = imerode(GUHG, strel('diamond', 3)); % Erode morfolojik i�lemi uygulan�yor
figure,imshow(GUHG);
GUHG = filter2(fspecial('average', 3), GUHG); % Kenarl�klar� kal�nla�t�r�yoruz
figure,imshow(GUHG);

%
[vektor, sinir] = bwboundaries(GUHG, 4, 'noholes'); % Objelerin s�n�rlar�n� se�er
 ozellik = regionprops(sinir, 'basic'); % objelerin �zelliklerini elde eder
 figure, imshow(OrjinalGoruntu); % Orjinal resmi ekrana basar
 

 for i=1 : length(vektor) % Resimdeki t�m objeleri tarar
 
 koordinat = ozellik(i).BoundingBox; % S�n�r koordinatlar
 x1 = koordinat(1);
 y1 = koordinat(2);
 x2 = x1 + koordinat(3);
 y2 = y1 + koordinat(4);
 %levhay� k�rpmak i�in koordinatlar al�nd�
      c1=x1;
      c2=x2;
      d1=y1;
      d2=y2;
 yatayKoordinat = [x1 x2 x2 x1 x1];
 dikeyKoordinat = [y1 y1 y2 y2 y1];
 
 x2 = floor(x2);
 y2 = floor(y2);
 
 LevhayiBul = bweuler(GUHG(y1:y2, x1:x2)); % Objenin i�inde bo�luk var m�?

 if(LevhayiBul<1) % E�er objenin i�inde bo�luk veya bo�luklar varsa bu bir trafik i�aretidir, �er�eve i�ine al
 hold on
 plot(yatayKoordinat, dikeyKoordinat, 'g-', 'LineWidth', 2);
 hold off
 %a=imread(Goruntu);
 %a=imcrop(OrjinalGoruntu(y1:y2 ,x1:x2));
 end

 end
     a=imcrop(OrjinalGoruntu,[c1 d1 c2 d2]);
     a=imresize(a,[100 100]);%%boyutlar� 100*100 olarak ayarland�
     hog(a); 

