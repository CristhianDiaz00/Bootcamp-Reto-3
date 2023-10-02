//Usando INNER JOIN crear vistas que generen:
//a.Clientes que no tienen pedido facturado
CREATE OR REPLACE VIEW Cliente_sinpedido_facturado AS
SELECT c.cod_clie,c.nom_corto,c.sal_deud_ante, p.val_esta_pedi
FROM bootcamp_pedidos p
INNER JOIN bootcamp_clientes c
ON p.COD_CLIE = c.COD_CLIE
WHERE VAL_ESTA_PEDI not like 'FACTURADO';

//b. Pedidos cuyo cliente no existe en la tabla Clientes
CREATE OR REPLACE VIEW pedido_sincliente AS
SELECT P.*
FROM bootcamp_pedidos P
LEFT JOIN bootcamp_clientes C 
ON P.COD_CLIE = C.Cod_clie
WHERE C.Cod_clie IS NULL;


//Crear vistas para mostrar:
//a. Acumulado de atributo VAL_MONT_SOLI agrupado por estado de Pedido, Regi�n de
//aquellos pedidos facturados en junio, considerar para ello que el codigo de cliente
//exista en la tabla Cliente

CREATE OR REPLACE VIEW ACUMULADO_VAL_MONT_SOLI AS
SELECT P.VAL_ESTA_PEDI, P.COD_REGI, SUM(P.VAL_MONT_SOLI) AS ACUMULADO
FROM bootcamp_pedidos P 
INNER JOIN bootcamp_clientes C
ON P.COD_CLIE = C.COD_CLIE 
WHERE P.VAL_ESTA_PEDI = 'FACTURADO' AND TO_DATE(P.FEC_FACT, 'DD/MM/YYYY') LIKE '%/06/%'
GROUP BY P.VAL_ESTA_PEDI, P.COD_REGI;



//b. En base a la consulta anterior, mostrar una columna adicional que contenga el total de
//registros por cada agrupaci�n y condicionar a que se muestre solo aquellos que tengan
//m�s de 500 registros agrupados

CREATE OR REPLACE VIEW TOTALREGISTROS AS
SELECT P.VAL_ESTA_PEDI, P.COD_REGI, SUM(P.VAL_MONT_SOLI) AS ACUMULADO, COUNT(*) AS TOTALREGISTROS
FROM bootcamp_pedidos P
INNER JOIN bootcamp_clientes C
ON P.COD_CLIE = C.COD_CLIE
WHERE P.VAL_ESTA_PEDI = 'FACTURADO' AND TO_DATE(P.FEC_FACT, 'DD/MM/YYYY') LIKE '%/06/%'
GROUP BY P.VAL_ESTA_PEDI, P.COD_REGI
HAVING COUNT(*)>500;
