SELECT *,
    (sale_price - AVG(sale_price) OVER()) / STDEV(sale_price) OVER() AS sale_price_zscore
FROM veri


SELECT *,
    CASE WHEN STDEV(sale_price) OVER (PARTITION BY neighborhood, building_class_category) = 0
         THEN NULL
         ELSE (sale_price - AVG(sale_price) OVER (PARTITION BY neighborhood, building_class_category)) /
              STDEV(sale_price) OVER (PARTITION BY neighborhood, building_class_category)
    END AS sale_price_zscore_neighborhood
FROM veri


-- Add a column for "square_ft_per_unit"
ALTER TABLE veri
ADD square_ft_per_unit DECIMAL(18, 2); -- Adjust the precision and scale as needed

-- Update the new column with the calculated values
UPDATE veri
SET square_ft_per_unit = 
    CASE 
        WHEN total_units <> 0 THEN land_square_feet / total_units
        ELSE NULL -- or any default value you prefer
    END;

ALTER TABLE veri
ADD price_per_unit DECIMAL(10,2);

UPDATE veri
SET price_per_unit =
  CASE WHEN total_units = 0 THEN NULL
       ELSE sale_price / total_units
  END;