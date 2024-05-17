 /*
Modèle GUSEK pour résoudre le problème de base du projet de CL03

Pour rappel le problème est le suivant :
On considère la distribution truckload de fioul domestique entre des dépôts de carburants et des gros
clients industriels.
On connait le nombre de dépôts n le nombre de clients m, le stock de fioul Ai de
chaque dépôt i= 1,2,...,m (en m3), la demande de fioul Bj de chaque client j=1,2,...,n (en m3 ) et
les coûts de transport Cij entre dépôts et clients (en euros/m 3 ). Chaque dépôt peut livrer plusieurs
clients et chaque client peut être livré par plusieurs dépôts.
L'objectif est de déterminer les quantités livrées par chaque dépôt à chaque client, pour satisfaire
les demandes et minimiser le coût total de transport.
Le stock total des dépôts est au moins égal à la demande totale, sinon il n'y a pas de solution.

Dans ce modèle on ajoute les contraintes sur les véhicules :
- capacité max dans les camions C1 m^3
- cout fixe F1
- couts de transports précédents
- autant de camion que l'on veut sur les trajets
*/

/* Parametres */

param n, integer; # le nombre de client indicés par j
param B {j in 1..n}, integer; # la demande en fioul des clients en m3
param m, integer; # le nombre de dépôts indicés par i
param A {i in 1..m}, integer; # le stock des dépôts en m3
param C {i in 1..m, j in 1..n}; # Le cout  de transport en €/m3 du dépot i vers le client j

param C1; # capacité des camions 1
param F1; # coût fixe des camions 1
param C2; # capacité des camions 2
param F2; # coût fixe des camions 2


/* Variables */

var x {i in 1..m, j in 1..n} >=0; # la quantité livré du dépôt i vers le client j.
# Pas besoins de préciser integer ici : par propriété les solutions seront entières.

# Nombre de camion
var N1 {i in 1..m, j in 1..n}, integer >=0;
var N2 {i in 1..m, j in 1..n}, integer >=0;

/* Le modèle */

#Objectif : Minimiser le coût de transport
minimize cost : sum{i in 1..m, j in 1..n} (x[i,j]*C[i,j] + N1[i,j]*F1 + N2[i,j]*F2);

# Contrainte de satisfaction : il faut que la somme livrés à chaque client j soit supérieur ou égale à la demande
satify {j in 1..n} : sum {i in 1..m} x[i,j] >= B[j];

# La somme livrée par un dépôt i ne doit pas être supérieure à son stock
stock {i in 1..m} : sum {j in 1..n} x[i,j] <= A[i];

# contrainte artificielle qui vérifie la faisabilité du problème : on a plus de fioul que de demande.
#feasability : sum {i in 1..m} A[i] >= sum {j in 1..n} B[j];

# vérifie combien de camion par trajet
number_of_truck1 {i in 1..m, j in 1..n} : N1[i,j]*C1 +N2[i,j]*C2 >= x[i,j];

solve;

/* Afficher les résultats */
# display cost,x;

printf "\n === === Afficher les resultats === ===\n\n";
printf "Cout total : %d\n", cost;
for {j in 1.. n} :
{
      printf "Client %d:\n", j;
      printf {i in 1..m: x[i,j] != 0} "   Depot %d : %d m3, %d camions 1 et %d camions 2\n", i, x[i,j], N1[i,j], N2[i,j]; 
}

printf "Nombre de camion mobilises 1 : %d\n", sum {i in 1..m, j in 1..n} N1[i,j];
printf "Pour un total de : %d \n", sum {i in 1..m, j in 1..n} N1[i,j]*F1;
printf "Nombre de camion mobilises 2 : %d\n", sum {i in 1..m, j in 1..n} N2[i,j];
printf "Pour un total de : %d \n", sum {i in 1..m, j in 1..n} N2[i,j]*F2;

end;
