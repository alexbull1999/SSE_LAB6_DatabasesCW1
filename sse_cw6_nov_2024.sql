-- Q1 returns (country,capital,population)
SELECT name AS country, capital, population
FROM country
WHERE population>100000000
ORDER BY population DESC
;

-- Q2 returns (continent,country)
SELECT encompasses.continent, country.name
FROM encompasses JOIN country
	ON encompasses.country=country.code
ORDER BY continent, country ASC -- assuming ascending order meant
;

-- Q3 returns (organization_name,country_name))
SELECT organization.name AS organization_name, country.name AS country_name
FROM is_member JOIN organization
	ON is_member.organization=organization.abbreviation
	JOIN country
	ON is_member.country=country.code
WHERE type='member'
;

-- Q4 returns (country,neighbour,length)
SELECT c1.name AS country, c2.name AS neighbour, length
FROM borders
	JOIN country AS c1
	ON borders.country1=c1.code OR borders.country2=c1.code
	JOIN country AS c2
	ON borders.country2=c2.code OR borders.country1=c2.code
WHERE c2.code <> c1.code
ORDER BY c1.name, length DESC, neighbour
;

-- Q5 returns (name,type)
SELECT name, 'Country' AS type
FROM country
UNION
SELECT name, 'Province' AS type
FROM province
UNION
SELECT name, 'City' AS type
FROM city
ORDER BY name, type
;

-- Q6 returns (country,population)
SELECT name, population
FROM country
WHERE country.code NOT IN (SELECT country1
													FROM borders
													UNION
													SELECT country2
													FROM borders)
ORDER BY population DESC, country
;

-- Q7 returns (country,no_neighbours,border_length)
SELECT c1.name AS country, 
				COUNT(b.neighbour) AS no_neighbours, 
				SUM(b.length) AS length
FROM (SELECT country1 AS country,
						 country2 AS neighbour,
						 length
			FROM borders
			UNION ALL
			SELECT country2 AS country,
						 country1 AS neighbour,
						 length
			FROM borders) AS b
	JOIN country AS c1 
	ON b.country=c1.code
GROUP BY c1.name
ORDER BY c1.name
;

-- Q8 returns (organization,no_members,population)
SELECT organization.name AS organization, 
			 COUNT(country.name) AS no_members,
			 SUM(country.population) AS population
FROM organization
		 JOIN is_member ON organization.abbreviation=is_member.organization
		 JOIN country ON is_member.country=country.code
GROUP BY organization.name
HAVING COUNT(country.name)>=20
ORDER BY organization.name, COUNT(country.name), SUM(country.population)
;
