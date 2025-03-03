%Fonction qui calcule la distance d'une serie de points mesur�s avec la 
%courbe th�rique de FACS
%Les differents param�tres sont
% Les ouvertures numeriques vers l'avant a_min et a_max
% L'ouverture num�rique sur le cot� b_max
% Les facteurs homoth�tiques lx et ly qui permettent de superposer les
% courbes

%Dans ce cas, on ne construira pas les fits polynomiaux des courbes de
%mesure ni meme des courbes theoriques


function result=distance(v)

a_min=v(1);
a_max=v(2);
index=v(3);
lx=v(4);
ly=v(5);
lz=v(6)

mesure=textread('mesure3.txt');
theory=textread('soja_theory_fluo_matin.txt');


    theory(:,1)=theory(:,1)*lx;  %FSH 1
    theory(:,2)=theory(:,2)*ly;  %SSH 0.97
    %theory(:,3)=theory(:,3)*6.9; %FL 6.9
  
sm=size(mesure);
sa=size(theory);

[fs_fit,S_fs,mu_fs]=polyfit(theory(:,4),theory(:,1),14);
fs_interp=polyval(fs_fit,theory(:,4),[],mu_fs);

[ss_fit,S_ss,mu_ss]=polyfit(theory(:,4),theory(:,2),3);
ss_interp=polyval(ss_fit,theory(:,4),[],mu_ss);

    
%creation des vecteurs de calcul
%creation de la matrice de calcul : lignes : mesure / colonne : interpolation
%on calcule la distance entre chaque point de mesure et les points de l'interpolation

%Calcul de la diff�rence des abscisses
%--------------------------------------

Xunity_m=ones(1,sa(1)); %Ligne unitaire d'un nombre de collones egale a la taille du fichier de mesure
Xm=mesure(:,1);         %Vecteur de l'abscice FS mesur�e
Xmes=Xm*Xunity_m;       %Matrice

Xunity_f=ones(sm(1),1);
Xf=fs_interp;
Xfit=Xunity_f*(Xf');

DX=Xmes-Xfit;

%Calcul de la diff�rence des ordonn�es
%--------------------------------------

Yunity_m=ones(1,sa(1));
Ym=mesure(:,2); 
Ymes=Ym*Yunity_m;

Yunity_f=ones(sm(1),1);
Yf=ss_interp;
Yfit=Yunity_f*(Yf');

DY=Ymes-Yfit;

%Distance calcul�e : distance normale quadratique
%------------------------------------------------

d=((DX).^2+(DY).^2).^0.5;
[A,I]=min(d');

%Construction de la nouvelle courbe
%alpha=3.78e-7;
%rayons=theory(:,4).';


%for i=1:sm(1)
   % lisse(i,1)=fs_interp(I(i));
   % lisse(i,2)=ss_interp(I(i));
   % lisse(i,3)=rayons(I(i));
   % lisse(i,4)=alpha*rayons(I(i))^3;
    %end


%figure
 %   plot(mesure(:,2),mesure(:,1),'g*','markersize',1)
 %   hold on
 %   xlabel('FL')
 %   ylabel('FS')
 %   plot(lisse(:,2),lisse(:,1),'m+','markersize',3)
 %   hold off
    
    
%figure

%subplot(2,1,1)
%hist(lisse(:,3),50);
%title('Histogramme des tailles ajust�')

%ray_f=(mesure(:,3)/alpha).^(1/3);

%subplot(2,1,2)
%hist(ray_f,50);
%title('Histogramme des tailles r�el')

result=sum(A)/sm(1);

fid = fopen('resultat.txt','a+');


%for j=1:nombre_total
    %fprintf(fid,'%g\t %g\t  %g\t %g\r',Cfor_f(j),C90_f(j),fluo_f(j),rayon(j));
    fprintf(fid,'%g\t %g\t %g\r',lx,ly,result);
    %end

fclose(fid);
%result=lisse;

