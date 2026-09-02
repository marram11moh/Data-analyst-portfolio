-- ============================================================
-- المرحلة 2: استعلامات تحليلية على قاعدة eastern_province
-- ============================================================

-- ------------------------------------------------------------
-- 1) السكان: ترتيب المحافظات حسب إجمالي عدد السكان

SELECT g.governorate_name,
       p.total_population,
       p.saudi_total,
       p.non_saudi_total,
       ROUND(100.0 * p.non_saudi_total / p.total_population, 1) AS pct_non_saudi
FROM population p
JOIN governorates g ON g.governorate_id = p.governorate_id
ORDER BY p.total_population DESC;

-- ------------------------------------------------------------
-- 2) الصحة: أفضل وأسوأ المحافظات من ناحية التغطية الصحية
--    (نجمع أسرّة المستشفيات + أطباء الرعاية الأولية، وننسبها للسكان)

SELECT g.governorate_name,
       p.total_population,
       h.total_beds,
       h.beds_per_1000,
       hc.total_physicians AS primary_care_physicians,
       hc.physicians_per_10000
FROM governorates g
JOIN population p ON p.governorate_id = g.governorate_id
JOIN hospitals h ON h.governorate_id = g.governorate_id
JOIN healthcare_centers hc ON hc.governorate_id = g.governorate_id
ORDER BY h.beds_per_1000 DESC;

-- ------------------------------------------------------------
-- 3) التعليم: الفجوة بين البنين والبنات (متوسط عدد الطلاب لكل معلم)
--    مجمّعة على مستوى المنطقة كلها، حسب الجنس والمرحلة

SELECT gender,
       education_level,
       SUM(students)  AS total_students,
       SUM(teachers)  AS total_teachers,
       ROUND(SUM(students)::NUMERIC / NULLIF(SUM(teachers), 0), 1) AS students_per_teacher
FROM education
GROUP BY gender, education_level
ORDER BY education_level,
         CASE education_level WHEN 'Primary' THEN 1 WHEN 'Intermediate' THEN 2 ELSE 3 END,
         gender;

-- ------------------------------------------------------------
-- 4) الاقتصاد: أكبر 5 أنشطة اقتصادية من ناحية الإيرادات،
--    ومتوسط الإيراد لكل منشأة (يكشف مين الأكثر كفاءة مو بس الأكبر)

SELECT e.economic_activity,
       es.total AS num_establishments,
       e.revenue_thousand_sar,
       ROUND(e.revenue_thousand_sar::NUMERIC / NULLIF(es.total, 0), 0) AS avg_revenue_per_establishment
FROM economic_indicators e
JOIN economic_establishments es ON es.economic_activity = e.economic_activity
ORDER BY e.revenue_thousand_sar DESC
LIMIT 5;

-- ------------------------------------------------------------
-- 5) التعليم العالي: أي المحافظات فيها فرص تعليم جامعي، والفجوة بين الطلاب والطالبات

SELECT g.governorate_name,
       he.state_universities AS main_universities,
       he.state_university_branches AS university_branches,
       he.private_universities,
       he.state_students_male + he.private_students_male AS total_male_students,
       he.state_students_female + he.private_students_female AS total_female_students
FROM higher_education he
JOIN governorates g ON g.governorate_id = he.governorate_id
ORDER BY (he.state_students_male + he.private_students_male
          + he.state_students_female + he.private_students_female) DESC;
