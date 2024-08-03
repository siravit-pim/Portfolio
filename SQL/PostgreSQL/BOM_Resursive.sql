WITH RECURSIVE parent AS (
    SELECT node.stock_keeping_unit_id,
           b.variation_id,
           node.part_id AS parent,
           node.stock_keeping_unit_id AS child, 
           node.multiplier,
           0 as level,
           ARRAY[bb.name_thai, b.name_thai ::VARCHAR] as nameth,
           ARRAY[bb.name_english, b.name_english ::VARCHAR] as nameen,
           ARRAY[TO_CHAR(CASE WHEN node.multiplier < 1 AND b.is_base_unit THEN node.multiplier * 1000 ELSE node.multiplier END, 'FM999999990')] as value
    FROM dim_bill_of_materials node
    LEFT JOIN dim_stock_keeping_units bb ON bb.id = node.stock_keeping_unit_id --parent uom
    LEFT JOIN dim_stock_keeping_units b ON b.id = node.part_id
    WHERE node.multiplier >= 1
  
   		UNION 

    SELECT parent.stock_keeping_unit_id,
           parent.variation_id,
           child.part_id,
           child.stock_keeping_unit_id,
           child.multiplier,
           parent.level + 1,
           array_append(parent.nameth, b.name_thai),
           array_append(parent.nameen, b.name_english),
           array_append(parent.value, TO_CHAR(CASE WHEN child.multiplier < 1 AND b.is_base_unit THEN  child.multiplier * 1000 ELSE child.multiplier END , 'FM999999990'))
    FROM dim_bill_of_materials child
    JOIN parent ON parent.parent = child.stock_keeping_unit_id 
    LEFT JOIN dim_stock_keeping_units b ON b.id = child.part_id
), mergeStr AS (
SELECT  
    a.stock_keeping_unit_id,
    a.value,
    a.nameth,
    a.nameen,
    array_to_string(a.value, ' x ') as value_str,
    array_to_string(a.nameth, ' ') as uom_th_str,
    array_to_string(a.nameen, ' ') as uom_en_str,
    d.name_thai as name1_TH,
    e.name_thai as name2_TH,
    c.name_thai as name3_TH,    
    e.name_english as name1_EN,
    d.name_english as name2_EN,
    c.name_english as name3_EN,
    c.id as variation_id,
    d.id as family_id,
    e.id as brand_id
FROM parent a
LEFT JOIN dim_variations c ON c.id = a.variation_id
LEFT JOIN dim_families d ON c.family_id = d.id
LEFT JOIN dim_brands e ON d.brand_id = e.id
)
SELECT
    stock_keeping_unit_id,
    TRIM(
        name1_TH || ' ' || name2_TH || ' ' || name3_TH || ' ' || uom_th_str || ' (' || value_str || ' )' ) as name_th, 
    TRIM(
        name1_EN || ' ' || name2_EN || ' ' || name3_EN || ' ' || uom_en_str || ' (' || value_str || ' )' ) as name_en,
    variation_id,
    family_id,
    brand_id
FROM mergeStr
WHERE array_length(value, 1) >= 5;
