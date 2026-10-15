-- 2026-10-14. F999 (результаты бланков 777/888/999/889/1011): индекс по Plan_Id уже есть (внешний ключ),
-- а по patientId и kdoId нет — поиск по ним читал всю таблицу, система подвисала. Данные не меняются.
-- Если индекс уже есть, MySQL ответит «Duplicate key name» — это не страшно.
Create Index ix_f999_patient On F999 (patientId);
Create Index ix_f999_kdo On F999 (kdoId);
