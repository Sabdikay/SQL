
SELECT 
    s2.ing_name,
    s2.ordered_weight,
    ing.ing_weight,
    inv.quantity,
    ing.ing_weight * IFNULL(inv.quantity, 0) AS total_inv_weight,
    (ing.ing_weight * IFNULL(inv.quantity, 0)) - s2.ordered_weight AS remaining_weight
FROM (
    SELECT
        ing_id,
        ing_name,
        SUM(order_quantity * recipe_quantity) AS ordered_weight
    FROM (
        SELECT
            o.item_id,
            i.sku,
            i.item_name,
            r.ing_id,
            ing.ing_name,
            r.quantity AS recipe_quantity,
            SUM(o.quantity) AS order_quantity,
            ing.ing_weight,
            ing.ing_price
        FROM 
            Orders o
            LEFT JOIN Item i ON o.item_id = i.item_id
            LEFT JOIN Recipe r ON i.sku = r.recipe_id
            LEFT JOIN Ingredient ing ON ing.ing_id = r.ing_id
        GROUP BY 
            o.item_id, i.sku, i.item_name, r.ing_id, r.quantity, ing.ing_name, ing.ing_weight, ing.ing_price
    ) s1
    GROUP BY ing_id, ing_name
) s2
LEFT JOIN Inventory inv ON TRIM(inv.item_id) = TRIM(s2.ing_id)
LEFT JOIN Ingredient ing ON TRIM(ing.ing_id) = TRIM(s2.ing_id);
