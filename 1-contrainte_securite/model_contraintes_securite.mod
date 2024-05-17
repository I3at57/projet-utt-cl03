 /*
Modèle GUSEK pour résoudre le problème de base du projet de CL03

Pour rappel le problème est le suivant :
On considère la distribution truckload de fioul domestique entre des dépôts de carburants et des gros
clients industriels.
On connait le nombre de dépôts n le nombre de clients m, le stock de fioul Ai de
chaque dépôt i= 1,2,…,m (en m3), la demande de fioul Bj de chaque client j=1,2,…,n (en m3 ) et
les coûts de transport Cij entre dépôts et clients (en euros/m 3 ). Chaque dépôt peut livrer plusieurs
clients et chaque client peut être livré par plusieurs dépôts.
L'objectif est de déterminer les quantités livrées par chaque dépôt à chaque client, pour satisfaire
les demandes et minimiser le coût total de transport.
Le stock total des dépôts est au moins égal à la demande totale, sinon il n'y a pas de solution.

De plus, on veut par sécurité que chaque client soit livré par au moins 2 dépôts.
*/

/* Parametres */

param n, integer; # le nombre de client indicés par j
param B {j in 1..n}, integer; # la demande en fioul des clients en m3
param m, integer; # le nombre de dépôts indicés par i
param A {i in 1..m}, integer; # le stock des dépôts en m3
param C {i in 1..m, j in 1..n}; # Le cout  de transport en €/m3 du dépot i vers le client j

param s, integer; # nombre minimum de dépôt livrant chaque client par sécurité

# Big M
param M := sum {j in 1..n} B[j];

/* Variables */

# Pas besoins de préciser integer ici : par propriété les solutions seront entières.
var x {i in 1..m, j in 1..n} >=0; # la quantité livré du dépôt i vers le client j.

# y = 1 si l'on livre le client j avec le dépot i
var y {i in 1..m, j in 1..n}, binary;

/* Le modèle */

#Objectif : Minimiser le coût de transport
minimize cost : sum {i in 1..m, j in 1..n} x[i,j] * C[i,j];

# Contrainte de satisfaction : il faut que la somme livrés à chaque client j soit supérieur ou égale à la demande
satify {j in 1..n} : sum {i in 1..m} x[i,j] >= B[j];

# La somme livrée par un dépôt i ne doit pas être supérieure à son stock
stock {i in 1..m} : sum {j in 1..n} x[i,j] <= A[i];

# contrainte artificielle qui vérifie la faisabilité du problème : on a plus de fioul que de demande.
feasability : sum {i in 1..m} A[i] >= sum {j in 1..n} B[j];

# Contrainte de livraison, on ne livre que si yij = 1
livraison_1 {i in 1..m, j in 1..n} : x[i,j] <= y[i,j] * M;
livraison_2 {i in 1..m, j in 1..n} : x[i,j] >= y[i,j];

#Remplace livraison_1 pour appliquer une politique 70%/30%
#livraison_1 {i in 1..m, j in 1..n} : x[i,j] <= y[i,j] * B[j] * 0.7;

# Contrainte de sécurité
safety {j in 1..n} : sum {i in 1..m} y[i,j] >= s;

solve;

/* Afficher les résultats */
# display cost,x;

printf "\n === === Afficher les resultats === ===\n\n";
printf "Cout total : %d\n", cost;
for {j in 1.. n} :
{
      printf "Client %d:\n", j;
      #printf {i in 1..m: x[i,j] != 0} "    Depot %d : %d m3\n", i, x[i,j];
      
      # Politique 70%/30%
      printf {i in 1..m: x[i,j] != 0} "    Depot %d : %f m3\n", i, x[i,j];
}

end;