% System D
% This script is a quick and dirty work around that is taken almost
% directly from the ESP300 control software.  The problem is that the Older
% motor is not being recognized by the motion controller

global ESP
global coordpoint12
global coordpoint11
global coordpoint22
global coordpoint21
global coordpoint32
global coordpoint31
global focale %diametre tache focale
global indiceAxe1MAX
global j
%% Variables to set
nom_fichier='Rat_Name';
coordpoint12 = 0;
coordpoint11 = 0;
coordpoint31 = 0;
coordpoint32 = 0;
focale = 2;


try
    fclose(ESP)
end
ESP = visa('ni', 'GPIB0::13::instr');
fopen(ESP);

%reglage des vitesses
setvelocity(ESP, 1, 5);% 01VA10 correspond a une vitesse de 10mm/s
% setvelocity(ESP, 2, 5);
c=num2str(findvelocity(ESP, 3));
set(handles.v,'string',c);

%Positionnement dans le coin haut droit du cube definissant la tumeur
% focale=str2num(get(handles.dimfocale,'String'));
foc=num2str(focale);
foc2=num2str(focale);
long_balayage=num2str(abs(coordpoint31-coordpoint32)+3*focale);

temp1= min(coordpoint11,coordpoint12)+0.5*focale;
pause(2);
set(handles.text17,'string',num2str(reldisplace(ESP, 1, temp1)));

% temp2= min(coordpoint21,coordpoint22)+0.5*focale;
% pause(2)
% set(handles.text21,'string',num2str(reldisplace(ESP, 2, temp2)));

temp3= min(coordpoint31,coordpoint32)-1.5*focale;
pause(2)
set(handles.text22,'string',num2str(reldisplace(ESP, 3, temp3)));


%demarrer generateur ici
msgbox('ALLUMER GENERATEUR PUIS PRESSER UNE TOUCHE')
pause

try
    fclose(ESP)
end
ESP = visa('ni', 'GPIB0::13::instr');

pause(3)

indiceAxe1MAX=round((abs(coordpoint11-coordpoint12))/focale);  % je prend l'arrondi pour ne pas traiter au maximum 0.99mm de tumeur sur tous les plans horizontaux. On traite donc parfois a cheval sur la peau
indiceAxe2MAX = 1; % floor((abs(coordpoint21-coordpoint22))/focale);  %si dimension tumeur/2 pas un entier prend l'entier en dessous.On ne traite pas au maximum 1,9mm de tumeur pour eviter de bruler la peau du bout de la tumeur

%debut balayage tumeur

for i=1:indiceAxe2MAX
        disp('plan')  
    %balayage dans le plan axe1,axe3
    for j=1:indiceAxe1MAX
        reldisplace(ESP, 3, str2num(long_balayage));
        if j==indiceAxe1MAX
            long_balayage=num2str(str2num(long_balayage)*(-1)); 
            display('dernier balayage')
            break                     %n'effectue pas le deplacement suivnt l'axe 2 pour le dernier plan de traitement
        end
        reldisplace(ESP, 1, str2num(foc));
        long_balayage=num2str(str2num(long_balayage)*(-1));   %on balaye dans l'autre sens
    end
    
    if i==indiceAxe2MAX
        display('dernier plan')
        break                     %n'effectue pas le deplacement suivnt l'axe 2 pour le dernier plan de traitement
    else
        reldisplace(ESP, 2, str2num(foc2));
        foc=num2str(str2num(foc)*(-1));
    end
    % se deplace de la focale sur l'axe 2 pour balayage reste tumeur
end

msgbox('TRAITEMENT TERMINE')

%affiche la position finale
set(handles.text17,'string',num2str(findposition(ESP, 1)));
set(handles.text21,'string',num2str(findposition(ESP, 2)));
set(handles.text22,'string',num2str(findposition(ESP, 3)));
pause(1)
fclose(ESP);

a=clock; %vecteur contenant la date et l'heure

filename=sprintf('%s%s',nom_fichier,'.xls') %permet de creer un chaine de caractere incluant la variable nom fichier et l'extension.xls
recap=fopen(filename,'w'); %cree ou ouvre un fichier en ecriture (ecrase valeurs precedentes) c'est un pointeur sur le fichier que lon range dans la variable recap
fprintf(recap,'jour mois annee \theure \tmin_axe_1 \tmax_axe_1 \tmin_axe_2 \tmax_axe_2 \tmin_axe_3 \tmax_axe_3 \tnombre_balayages_axe1 \tnombre_balayages_axe2 \tdim_focale \tvitesse_balayage\t\n'); %ecriture des noms de colonnes \t met une tabulation \n permet d'aller a la ligne \r revient au debut de la ligne \b revient d'un caractere en arriere
fprintf(recap,'%d %d %d \t%d %d \t%f \t%f \t%f \t%f \t%f \t%f \t%f \t%f \t%f \t%s\n', a(3), a(2), a(1), a(4), a(5),coordpoint11,coordpoint12,coordpoint21,coordpoint22,coordpoint31,coordpoint32,indiceAxe1MAX,indiceAxe2MAX,focale,get(handles.vitessebalayage,'String')); %precise le type de variable %d entier %f flottant %s chaine de caractere %x complexe et affiche la valeur de ces variables
% fprintf(recap,'test'); %ecrit dans le fichier
fclose(recap);  %ferme le pointeur sur le fichier
set(handles.nom,'string','entrer');