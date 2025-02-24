include "table.mzn";
int: min_energy = 3300;
int: min_protein = 500;
int: max_salt = 180;
int: max_fat = 320;
int: budget;

enum FOOD = {icecream, banana, chocolatecake, lasagna, steak, rice, chips, brocolli, beans};

enum FEATURE = {name, energy, protein, salt, fat, cost};

set of FOOD: desserts = {icecream, banana, chocolatecake};
set of FOOD: mains = {lasagna, steak, rice};
set of FOOD: sides = {chips, brocolli, beans};

array[FOOD, FEATURE] of int: dd = [|icecream, 1200, 50, 10, 120, 400
                                   |banana, 800, 120, 5, 20, 120
                                   |chocolatecake, 2500, 400, 20, 100, 600
                                   |lasagna, 3000, 200, 100, 250, 450
                                   |steak, 1800, 800, 50, 100, 1200
                                   |rice, 1200, 50, 5, 20, 100
                                   |chips, 2000, 50, 200, 200, 250
                                   |brocolli, 700, 100, 10, 10, 125
                                   |beans, 1900, 250, 60, 90, 150 |];

% set of FOOD: special_foods;    Conjunto de comidas especiales
% int: max_special_foods;        Máximo de comidas especiales que podemos utilizar
    
array[FEATURE] of var int: main;
array[FEATURE] of var int: side;
array[FEATURE] of var int: dessert;

output ["main = ", show(to_enum(FOOD,main[name])),
        ", side = ", show(to_enum(FOOD,side[name])),
        ", dessert = ", show(to_enum(FOOD,dessert[name])), "\n",
        "cost = ", show(total_cost), "\n",
        "energy = ", show(total_energy), "\n",
        "protein = ", show(total_protein), "\n", 
        "fat = ", show(total_fat), "\n",
        "salt = ", show(total_salt), "\n"];

% Escribe el código a partir de aquí --------------------------------

var int: total_cost = main[cost] + side[cost] + dessert[cost];
var int: total_energy = main[energy] + side[energy] + dessert[energy];
var int: total_fat = main[fat] + side[fat] + dessert[fat];
var int: total_salt = main[salt] + side[salt] + dessert[salt];
var int: total_protein = main[protein] + side[protein] + dessert[protein];

constraint main[name] in mains;
constraint side[name] in sides;
constraint dessert[name] in desserts;

constraint table(main, dd);
constraint table(side, dd);
constraint table(dessert, dd);

constraint total_salt <= max_salt;

constraint total_protein >= min_protein;

constraint total_energy >= min_energy;

constraint total_fat <= max_fat;

constraint total_cost <= budget;

solve minimize total_cost;