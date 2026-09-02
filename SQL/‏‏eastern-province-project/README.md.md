# الملف التنموي للمنطقة الشرقية | Eastern Province Development Profile


### نظرة عامة
مشروع تحليل بيانات متكامل يغطي دورة العمل الكاملة لمحلل بيانات: من بيانات خام غير منظمة، إلى قاعدة بيانات مترابطة، إلى تحليل إحصائي، وصولًا إلى لوحة معلومات تفاعلية. المشروع يستعرض التركيبة السكانية والاقتصادية والتعليمية والصحية لمحافظات المنطقة الشرقية بالمملكة العربية السعودية.

### مصدر البيانات
كتاب إحصائي رسمي (على نمط بيانات الهيئة العامة للإحصاء) يغطي 12 محافظة بالمنطقة الشرقية، موزّع على 26 جدول بتنسيق Excel غير منتظم (رؤوس متعددة المستويات، خلايا مدمجة، عناوين مضمّنة داخل الصفوف).

### منهجية العمل

**1) التنظيف (Python):**
استُخدمت مكتبة `pandas` مع `openpyxl` لتفكيك الملف الفوضوي واستخراج 9 جداول نظيفة ومنظمة، مع إعادة تشكيل بيانات التعليم (Reshaping/Melting) من صيغة عريضة متكررة إلى جدول طويل موحّد.

**2) قاعدة البيانات (PostgreSQL):**
تصميم مخطط علائقي (Relational Schema) من جدول أبعاد واحد (المحافظات) وثمانية جداول حقائق مرتبطة به بمفاتيح أجنبية، وكتابة استعلامات تحليلية تستخدم JOIN متعدد الجداول، دوال تجميع، ونسب محسوبة.

**3) التحليل الإحصائي (Python + SciPy):**
اختبار الفرضيات إحصائيًا بدل الاكتفاء بالملاحظة البصرية — مثل التحقق عبر اختبار t المزدوج (Paired t-test) من أن الفجوة بين البنين والبنات في نسبة الطلاب لكل معلم فرق حقيقي إحصائيًا (p = 0.008) وليس مجرد تذبذب عشوائي.

**4) لوحة المعلومات (Power BI):**
ربط مباشر بقاعدة PostgreSQL (Import mode)، بناء مقاييس DAX محسوبة (Measures) تحاكي منطق SQL بدقة (مثل استخدام DIVIDE على المجاميع بدل متوسط النسب الفردية لتفادي تحيز الوزن)، وتصميم صفحة تفاعلية واحدة مع فلتر (Slicer) يُحدّث كل المؤشرات لحظيًا.

### أبرز الرؤى المستخرجة
- تباين واضح بنسبة السكان غير السعوديين بين المحافظات الصناعية (الجبيل، الخبر ~50%) والمحافظات السكنية التقليدية (القطيف، الأحساء ~13-18%)
- التغطية الصحية عادلة نسبيًا بين المحافظات بغض النظر عن حجم السكان (لا توجد علاقة إحصائية معنوية، p=0.477)
- فجوة معنوية إحصائيًا بين البنين والبنات بكثافة الفصول (p=0.008)
- قطاع التعدين يحقق أعلى متوسط إيراد لكل منشأة رغم قلة عدد المنشآت، بعكس قطاع التجزئة الكثيف عدديًا ومنخفض العائد نسبيًا

### المهارات المستخدمة
`Python` (pandas, scipy, matplotlib) · `SQL` (PostgreSQL: JOIN, GROUP BY, Window concepts, CTEs) · `Power BI` (DAX, Data Modeling, Relationships) · تنظيف البيانات وضمان جودتها · التحليل الإحصائي · تصميم لوحات المعلومات

---

## 🇬🇧 English Description

### Overview
An end-to-end data analytics project covering the full analyst workflow: from messy raw government data, to a normalized relational database, to statistical analysis, to an interactive dashboard. The project profiles the population, economy, education, and healthcare landscape of the 12 governorates of Saudi Arabia's Eastern Province.

### Data Source
An official statistical yearbook (GASTAT-style) covering the 12 governorates of the Eastern Province, spread across 26 irregularly formatted Excel sheets (multi-level headers, merged cells, titles embedded within data rows).

### Methodology

**1) Data Cleaning (Python):**
Used `pandas` and `openpyxl` to parse the irregular workbook and extract 9 clean, structured tables — including reshaping four repeated wide-format education sheets into a single tidy long-format table (melting by gender × sector × education level).

**2) Database Design (PostgreSQL):**
Designed a relational schema with one dimension table (governorates) and eight related fact tables linked by foreign keys, then wrote analytical queries using multi-table JOINs, aggregate functions, and calculated ratios.

**3) Statistical Analysis (Python + SciPy):**
Moved beyond visual observation to formal hypothesis testing — for example, a paired t-test confirmed that the gender gap in students-per-teacher ratio is statistically significant (p = 0.008), not random noise, while population size showed no significant correlation with healthcare bed capacity per capita (p = 0.477).

**4) Dashboard (Power BI):**
Connected directly to PostgreSQL (Import mode), built DAX measures that mirror the SQL logic precisely (e.g., using `DIVIDE` on summed totals rather than averaging individual ratios, to avoid weighting bias toward small governorates), and designed a single interactive page with a governorate slicer that updates every visual in real time.

### Key Insights
- Clear divide in non-Saudi population share between industrial governorates (Jubail, Khobar ~50%) and traditional residential ones (Qatif, Al-Ahsa ~13–18%)
- Healthcare bed capacity is distributed fairly evenly relative to population size, with no statistically significant correlation (p = 0.477)
- A statistically significant gender gap exists in class density / students-per-teacher ratio (p = 0.008)
- The mining sector generates the highest average revenue per establishment despite having far fewer establishments than retail, which is high-volume but comparatively low-yield per business

### Skills Demonstrated
`Python` (pandas, scipy, matplotlib) · `SQL` (PostgreSQL: JOINs, GROUP BY, aggregate queries) · `Power BI` (DAX, data modeling, relationships) · Data cleaning & quality assurance · Statistical analysis · Dashboard design
