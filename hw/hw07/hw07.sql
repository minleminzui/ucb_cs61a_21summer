CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";

CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur, 26 AS height UNION
  SELECT "barack"         , "short"      , 52           UNION
  SELECT "clinton"        , "long"       , 47           UNION
  SELECT "delano"         , "long"       , 46           UNION
  SELECT "eisenhower"     , "short"      , 35           UNION
  SELECT "fillmore"       , "curly"      , 32           UNION
  SELECT "grover"         , "short"      , 28           UNION
  SELECT "herbert"        , "curly"      , 31;

CREATE TABLE sizes AS
  SELECT "toy" AS size, 24 AS min, 28 AS max UNION
  SELECT "mini"       , 28       , 35        UNION
  SELECT "medium"     , 35       , 45        UNION
  SELECT "standard"   , 45       , 60;


-- The size of each dog
CREATE TABLE size_of_dogs AS
  SELECT name, size FROM dogs, sizes WHERE height > min AND height <= max;


-- All dogs with parents ordered by decreasing height of their parent
CREATE TABLE by_parent_height AS
  SELECT child FROM dogs, parents WHERE parent = name ORDER BY height DESC;


-- Filling out this helper table is optional
CREATE TABLE siblings AS
  SELECT  p1.child AS sib1, p2.child AS sib2 
  FROM parents AS p1, parents AS p2 
  WHERE p1.parent = p2.parent AND p1.child < p2.child;

-- Sentences about siblings that are the same size
CREATE TABLE sentences AS
  SELECT "The two siblings, " || sib1 || " plus " || sib2 || " have the same size: " || s1.size 
  FROM siblings, size_of_dogs AS s1, size_of_dogs AS s2
  WHERE s1.name = sib1 AND s2.name = sib2 AND s1.size = s2.size;


-- Ways to stack 4 dogs to a height of at least 175, ordered by total height
CREATE TABLE stacks_helper(dogs, stack_height, last_height, n);

-- Add your INSERT INTOs here
INSERT INTO stacks_helper SELECT name, height, height, 1 FROM dogs;
INSERT INTO stacks_helper SELECT dogs || ", " || d.name, stack_height + d.height, d.height, 2 
                          FROM dogs AS d, stacks_helper AS s 
                          WHERE d.height > last_height AND n = 1;
INSERT INTO stacks_helper SELECT dogs || ", " || d.name, stack_height + d.height, d.height, 3 
                          FROM dogs AS d, stacks_helper AS s 
                          WHERE d.height > last_height AND n = 2;
INSERT INTO stacks_helper SELECT dogs || ", " || d.name, stack_height + d.height, d.height, 4 
                          FROM dogs AS d, stacks_helper AS s 
                          WHERE d.height > last_height AND n = 3;

CREATE TABLE stacks AS
  SELECT dogs, stack_height FROM stacks_helper WHERE n = 4 AND stack_height > 175 ORDER BY stack_height ASC;


-- Total size for each fur type where all of the heights differ by no more than 30% from the average height
CREATE TABLE low_variance AS
  SELECT fur, SUM(height) FROM dogs GROUP BY fur HAVING height <= AVG(height) * 1.3 AND height >= AVG(height) * 0.7;


-- Heights and names of dogs that are above average in height among
-- dogs whose height has the same first digit.

-- not above_average but tallest, or you can't test it 
-- CREATE TABLE above_average AS
CREATE TABLE tallest AS 
  WITH digit_average(digit, average) AS (
    SELECT ROUND((AVG(height) / 10) - 0.5, 0), AVG(height) FROM dogs GROUP BY height / 10
  )
  SELECT height, name, d.height / 10 
  FROM digit_average AS da, dogs AS d 
  WHERE d.height / 10 = da.digit AND d.height > da.average ORDER BY height ASC;


-- non_parents is an optional, but recommended question
-- All non-parent relations ordered by height difference
CREATE TABLE non_parents as
  with
    grandparents(grandog, grandpup) as (
      select a.parent, b.child from parents as a, parents as b
        where a.child = b.parent
    ),
    ancestors(ancestor, descendent) as (
      select grandog, grandpup from grandparents union
      select ancestor, child from ancestors, parents
        where parent = descendent
    ),
    relations(first, second) as (
      select ancestor, descendent from ancestors union
      select descendent, ancestor from ancestors
    )
  select first, second from relations, dogs as f, dogs as s
    where first = f.name and second = s.name order by f.height-s.height;

