-- ============================================================
-- مشروع: الملف التنموي للمنطقة الشرقية (Eastern Province Profile)
-- المصدر: كتاب إحصائي لوزارة الاقتصاد/GASTAT عن المنطقة الشرقية
-- ============================================================

-- CREATE DATABASE eastern_province;
-- \c eastern_province

-- ------------------------------------------------------------
--  المحافظات

CREATE TABLE governorates (
    governorate_id   INT PRIMARY KEY,
    governorate_name VARCHAR(50) NOT NULL
);

-- ------------------------------------------------------------
-- السكان حسب المحافظة

CREATE TABLE population (
    governorate_id   INT PRIMARY KEY REFERENCES governorates(governorate_id),
    num_houses       INT,
    saudi_male       INT,
    saudi_female     INT,
    saudi_total      INT,
    non_saudi_male   INT,
    non_saudi_female INT,
    non_saudi_total  INT,
    total_male       INT,
    total_female     INT,
    total_population INT
);

-- ------------------------------------------------------------
-- المستشفيات حسب المحافظة

CREATE TABLE hospitals (
    governorate_id       INT PRIMARY KEY REFERENCES governorates(governorate_id),
    population            INT,
    govt_hospitals         INT,
    govt_beds              INT,
    govt_physicians        INT,
    private_hospitals      INT,
    private_beds           INT,
    private_physicians     INT,
    total_beds             INT,
    beds_per_1000           NUMERIC(5,2),
    total_physicians       INT,
    physicians_per_1000     NUMERIC(5,2)
);

-- ------------------------------------------------------------
-- مراكز الرعاية الصحية الأولية حسب المحافظة

CREATE TABLE healthcare_centers (
    governorate_id        INT PRIMARY KEY REFERENCES governorates(governorate_id),
    population              INT,
    govt_centers            INT,
    govt_physicians         INT,
    private_dispensaries    INT,
    private_physicians      INT,
    red_crescent_centers    INT,
    total_physicians        INT,
    physicians_per_10000    NUMERIC(5,2)
);

-- ------------------------------------------------------------
-- التعليم العالي حسب المحافظة 

CREATE TABLE higher_education (
    governorate_id            INT PRIMARY KEY REFERENCES governorates(governorate_id),
    state_universities          INT,
    state_university_branches   INT,
    state_students_male         INT,
    state_students_female       INT,
    state_staff_male            INT,
    state_staff_female          INT,
    private_universities        INT,
    private_students_male       INT,
    private_students_female     INT,
    private_staff_male          INT,
    private_staff_female        INT
);

-- ------------------------------------------------------------
-- التعليم العام (جدول موحّد: بنين/بنات x حكومي/أهلي x ابتدائي/متوسط/ثانوي)
-
CREATE TABLE education (
    education_id              SERIAL PRIMARY KEY,
    governorate_id             INT REFERENCES governorates(governorate_id),
    gender                     VARCHAR(10),   -- Boys / Girls
    sector                     VARCHAR(15),   -- Government / Private
    education_level            VARCHAR(15),   -- Primary / Intermediate / Secondary
    schools                    INT,
    classes                    INT,
    students                   INT,
    teachers                   INT,
    avg_class_size             NUMERIC(5,2),
    avg_students_per_teacher   NUMERIC(5,2)
);

-- ------------------------------------------------------------
-- المرافق الخدمية (فروع/مكاتب جهات حكومية) حسب المحافظة

CREATE TABLE service_facilities_by_governorate (
    governorate_id              INT PRIMARY KEY REFERENCES governorates(governorate_id),
    real_estate_dev_fund_branch   INT, real_estate_dev_fund_office  INT,
    industrial_dev_fund_branch    INT, industrial_dev_fund_office   INT,
    scsb_bank_branch               INT, scsb_bank_office             INT,
    ministry_of_transport_branch   INT, ministry_of_transport_office INT,
    ministry_of_water_branch       INT, ministry_of_water_office     INT,
    ministry_of_finance_branch     INT, ministry_of_finance_office   INT,
    ministry_of_planning_branch    INT, ministry_of_planning_office  INT,
    ministry_of_justice_branch     INT, ministry_of_justice_office   INT,
    retirement_branch               INT, retirement_office            INT,
    insurance_branch                 INT, insurance_office             INT
);

-- ------------------------------------------------------------
-- المنشآت الاقتصادية حسب النشاط 

CREATE TABLE economic_establishments (
    economic_activity  VARCHAR(100) PRIMARY KEY,
    private             INT,
    public              INT,
    non_profit          INT,
    total                INT
);

-- ------------------------------------------------------------
-- المؤشرات الاقتصادية حسب النشاط (بالآلاف ريال، على مستوى المنطقة)

CREATE TABLE economic_indicators (
    economic_activity            VARCHAR(100) PRIMARY KEY,
    revenue_thousand_sar           BIGINT,
    expenditure_thousand_sar        BIGINT,
    operating_surplus_thousand_sar  BIGINT
);

-- ============================================================

\copy governorates FROM 'C:\SQL\eastern-province-project\governorates.csv' DELIMITER ',' CSV HEADER;
\copy population FROM 'C:\SQL\eastern-province-project\population.csv' DELIMITER ',' CSV HEADER;
\copy hospitals FROM 'C:\SQL\eastern-province-project\hospitals.csv' DELIMITER ',' CSV HEADER;
\copy healthcare_centers FROM 'C:\SQL\eastern-province-project\healthcare_centers.csv' DELIMITER ',' CSV HEADER;
\copy higher_education FROM 'C:\SQL\eastern-province-project\higher_education.csv' DELIMITER ',' CSV HEADER;
\copy education(governorate_id, gender, sector, education_level, schools, classes, students, teachers, avg_class_size, avg_students_per_teacher) FROM 'C:\SQL\eastern-province-project\education.csv' DELIMITER ',' CSV HEADER;
\copy service_facilities_by_governorate FROM 'C:\SQL\eastern-province-project\service_facilities_by_governorate.csv' DELIMITER ',' CSV HEADER;
\copy economic_establishments FROM 'C:\SQL\eastern-province-project\economic_establishments.csv' DELIMITER ',' CSV HEADER;
\copy economic_indicators FROM 'C:\SQL\eastern-province-project\economic_indicators.csv' DELIMITER ',' CSV HEADER;

