/* Slide1- Vendas de músicas de rock por país  */
SELECT
  SUM(Quantity) Total,
  c.Country
FROM Track t
JOIN Genre g
  ON g.GenreId = t.GenreId
JOIN InvoiceLine i
  ON i.TrackId = t.TrackId
JOIN Invoice iv
  ON i.InvoiceId = iv.InvoiceId
JOIN Customer c
  ON c.CustomerId = iv.CustomerId
WHERE g.Name = 'Rock'
GROUP BY 2
ORDER BY 1 DESC
LIMIT 10

/* Slide2- 10 Artistas de Rock que mais faturam  */
SELECT
  ar.Name,
  SUM(i.UnitPrice * i.Quantity) Total
FROM Track t
JOIN Album a
  ON a.AlbumId = t.AlbumId
JOIN Artist ar
  ON ar.ArtistId = a.ArtistId
JOIN Genre g
  ON g.GenreId = t.GenreId
JOIN InvoiceLine i
  ON i.TrackId = t.TrackId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/* Slide3- 5 clientes que mais gastaram  */
SELECT
  c.FirstName||' '|| c.LastName Name,
  inv.CustomerID,
  SUM(i.Quantity * i.UnitPrice)
FROM InvoiceLine i
JOIN Invoice inv
  ON i.InvoiceId = inv.InvoiceId
JOIN Customer c
  ON inv.CustomerId = c.CustomerId
GROUP BY 2
ORDER BY 3 DESC
LIMIT 5

/* Slide4- as 10 músicas mais vendidas  */
SELECT
  t.Name ||'-'|| ar.Name Musica_Artista,
  SUM(i.Quantity) Compras
FROM InvoiceLine i
JOIN Track t
  ON t.TrackId = i.TrackId
JOIN Album a
  ON a.AlbumId = t.AlbumId
JOIN Artist ar
  ON a.ArtistId = ar.ArtistId
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/* Use sua consulta para retornar o e-mail, nome, sobrenome e gênero de todos os ouvintes
de Rock. Retorne sua lista ordenada alfabeticamente por endereço de e-mail,começando por A.
Você consegue encontrar um jeito de lidar com e-mailsduplicados para que ninguém receba vários e-mails? */

SELECT DISTINCT c.Email,c.FirstName,c.LastName,g.name
FROM Genre g
JOIN Track t
ON t.GenreId = g.GenreId
JOIN InvoiceLine il
ON il.TrackId = t.TrackId
JOIN Invoice i
ON il.InvoiceId = i.InvoiceId
JOIN Customer c
ON c.CustomerId = i.CustomerId
WHERE g.name = 'Rock'
Order by 1

/* Vamos convidar os artistas que mais escreveram as músicas de rock em nosso banco de dados. 
Escreva uma consulta que retorna o nome do Artist (artista) e a contagem total de músicas das
dez melhores bandas de rock. */

SELECT ar.ArtistId,ar.Name,COUNT(t.Name) Songs
FROM Track t
JOIN Album a
ON a.AlbumId = t.AlbumId
JOIN Artist ar
ON ar.ArtistId = a.ArtistId
JOIN Genre g
ON g.GenreId = t.GenreId
WHERE g.Name = 'Rock'
GROUP BY 2
Order by 3 DESC

/* Primeiro, descubra qual artista ganhou mais de acordo com InvoiceLines (linhas de faturamento) */

SELECT ar.ArtistId,ar.Name, SUM(i.UnitPrice*i.Quantity) Total
FROM Track t
JOIN Album a
ON a.AlbumId = t.AlbumId
JOIN Artist ar
ON ar.ArtistId = a.ArtistId
JOIN Genre g
ON g.GenreId = t.GenreId
JOIN InvoiceLine i
ON i.TrackId = t.TrackId
GROUP BY 1
ORDER BY 3 DESC

/* Agora use este artista para encontrar qual cliente gastou mais com este artista. */

WITH table1 AS (SELECT inv.CustomerId Cust_,SUM(i.UnitPrice*i.Quantity) Tot_
FROM InvoiceLine i
JOIN Invoice inv
ON i.InvoiceId = inv.InvoiceId
JOIN Track t
ON t.TrackId = i.TrackId
JOIN Album a
ON a.AlbumId = t.AlbumId
JOIN Artist ar
ON ar.ArtistId = A.ArtistId
WHERE ar.Name = 'Iron Maiden'
GROUP BY 1)

SELECT table1.Cust_,table1.Tot_
FROM table1
ORDER BY 2 DESC

/* Queremos descobrir o gênero musical mais popular em cada país. Determinamos o gênero
 mais popular como o gênero com o maior número de compras. Escreva uma consulta que
 retorna cada país juntamente a seu gênero mais vendido. Para países onde o número
 máximo de compras é compartilhado retorne todos os gêneros.

Para essa consulta você precisará usar as tabelas Invoice (fatura), InvoiceLine
 (linha de faturamento), Track (música), Customer (cliente) e Genre (gênero). */

WITH table1 AS (SELECT SUM(Quantity) Total, c.Country, g.Name , g.GenreId
FROM Track t
JOIN Genre g
ON g.GenreId = t.GenreId
JOIN InvoiceLine i
ON i.TrackId = t.TrackId
JOIN Invoice iv
ON i.InvoiceId = iv.InvoiceId
JOIN Customer c
ON c.CustomerId = iv.CustomerId
GROUP BY 2,3
ORDER BY 1 DESC)

SELECT  t1.Total,t1.Country,t1.Name,t1.GenreId
FROM table1 t1
JOIN table1 t2
ON t1.Country = t2.Country 
GROUP BY 2,3
HAVING t1.Total = MAX(t2.Total)
