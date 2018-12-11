function [] = trafikLevhaTespiti(Goruntu) % Ana Fonksiyon
 OrjinalGoruntu = imread(Goruntu); % Orjinal Resmi oku

HsvCevir= rgb2ntsc(OrjinalGoruntu); % RGB renk uzayýndan NTSC renk uzayýna dönüþüm yapýlýyor

HsvDegeri = HsvCevir(:,:,3); % HSV -&gt; 3. parametre yani value (brighness veya parlaklýk) kullanýlýyor
 
KaliteDegeri = filter2(fspecial('average', 2), HsvDegeri); % filtre kullanýlarak kalite arttýrýlýyor
 
GUHG = im2bw(10*KaliteDegeri,0.2); % Görüntü siyah-beyaz hale getiriliyor ve beyazlýklarýn belirginliði arttýrýlýyor // goruntüyü uygun hale getir
figure,imshow(GUHG);
GUHG = bwareaopen(GUHG, 30); % Küçük objeler temizleniyor
GUHG = imdilate(GUHG, strel('disk',4)); % Dilation morfolojik iþlemi uygulanýyor
figure,imshow(GUHG);
GUHG = imdilate(GUHG,strel('disk',1)); % Dilation morfolojik iþlemi uygulanýyor
figure,imshow(GUHG);
GUHG = imerode(GUHG, strel('diamond', 3)); % Erode morfolojik iþlemi uygulanýyor
figure,imshow(GUHG);
GUHG = filter2(fspecial('average', 3), GUHG); % Kenarlýklarý kalýnlaþtýrýyoruz
figure,imshow(GUHG);

%
[vektor, sinir] = bwboundaries(GUHG, 4, 'noholes'); % Objelerin sýnýrlarýný seçer
 ozellik = regionprops(sinir, 'basic'); % objelerin özelliklerini elde eder
 figure, imshow(OrjinalGoruntu); % Orjinal resmi ekrana basar
 

 for i=1 : length(vektor) % Resimdeki tüm objeleri tarar
 
 koordinat = ozellik(i).BoundingBox; % Sýnýr koordinatlar
 x1 = koordinat(1);
 y1 = koordinat(2);
 x2 = x1 + koordinat(3);
 y2 = y1 + koordinat(4);
 %levhayý kýrpmak için koordinatlar alýndý
      c1=x1;
      c2=x2;
      d1=y1;
      d2=y2;
 yatayKoordinat = [x1 x2 x2 x1 x1];
 dikeyKoordinat = [y1 y1 y2 y2 y1];
 
 x2 = floor(x2);
 y2 = floor(y2);
 
 LevhayiBul = bweuler(GUHG(y1:y2, x1:x2)); % Objenin içinde boþluk var mý?

 if(LevhayiBul<1) % Eðer objenin içinde boþluk veya boþluklar varsa bu bir trafik iþaretidir, çerçeve içine al
 hold on
 plot(yatayKoordinat, dikeyKoordinat, 'g-', 'LineWidth', 2);
 hold off
 %a=imread(Goruntu);
 %a=imcrop(OrjinalGoruntu(y1:y2 ,x1:x2));
 end

 end
     a=imcrop(OrjinalGoruntu,[c1 d1 c2 d2]);
     a=imresize(a,[100 100]);%%boyutlarý 100*100 olarak ayarlandý
     hog(a); 

