 /*
Mod�le GUSEK pour r�soudre le probl�me de base du projet de CL03

Pour rappel le probl�me est le suivant :
On consid�re la distribution truckload de fioul domestique entre des d�p�ts de carburants et des gros
clients industriels.
On connait le nombre de d�p�ts n le nombre de clients m, le stock de fioul Ai de
chaque d�p�t i= 1,2,�,m (en m3), la demande de fioul Bj de chaque client j=1,2,�,n (en m3 ) et
les co�ts de transport Cij entre d�p�ts et clients (en euros/m 3 ). Chaque d�p�t peut livrer plusieurs
clients et chaque client peut �tre livr� par plusieurs d�p�ts.
L'objectif est de d�terminer les quantit�s livr�es par chaque d�p�t � chaque client, pour satisfaire
les demandes et minimiser le co�t total de transport.
Le stock total des d�p�ts est au moins �gal � la demande totale, sinon il n'y a pas de solution.

Ce premier mod�le sert � r�soudre le probl�me initial tel que pr�sent� plu haut sans contraintes suppl�mentaires.
*/

/* Parametres */

param n, integer; # le nombre de client indic�s par j
param B {j in 1..n}, integer; # la demande en fioul des clients en m3
param m, integer; # le nombre de d�p�ts indic�s par i
param A {i in 1..m}, integer; # le stock des d�p�ts en m3
param C {i in 1..m, j in 1..n}; # Le cout  de transport en �/m3 du d�pot i vers le client j

/* Variables */

var x {i in 1..m, j in 1..n} >=0; # la quantit� livr� du d�p�t i vers le client j.
# Pas besoins de pr�ciser integer ici : par propri�t� les solutions seront enti�res.

/* Le mod�le */

#Objectif : Minimiser le co�t de transport
minimize cost : sum {i in 1..m, j in 1..n} x[i,j] * C[i,j];

# Contrainte de satisfaction : il faut que la somme livr�s � chaque client j soit sup�rieur ou �gale � la demande
satify {j in 1..n} : sum {i in 1..m} x[i,j] >= B[j];

# La somme livr�e par un d�p�t i ne doit pas �tre sup�rieure � son stock
stock {i in 1..m} : sum {j in 1..n} x[i,j] <= A[i];

# contrainte artificielle qui v�rifie la faisabilit� du probl�me : on a plus de fioul que de demande.
feasability : sum {i in 1..m} A[i] >= sum {j in 1..n} B[j];

solve;

/* Afficher les r�sultats */
# display cost,x; # pour un affichage rapide

printf "\n === === Afficher les resultats === ===\n\n";
printf "Cout total : %d\n", cost;
for {j in 1.. n} :
{
      printf "Client %d:\n", j;
      printf {i in 1..m: x[i,j] != 0} "    Depot %d : %d m3\n", i, x[i,j]; 
}

printf "\n === === Fin des r�sultats les resultats === ===\n\n";

end;
