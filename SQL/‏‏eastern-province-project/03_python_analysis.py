

import pandas as pd
from sqlalchemy import create_engine
from scipy import stats
import matplotlib.pyplot as plt

# ------------------------------------------------------------
# 1) الاتصال بالقاعدة

# ------------------------------------------------------------
# 2) نسحب الجداول المهمة كـ DataFrames

governorates = pd.read_sql("SELECT * FROM governorates", engine)
population   = pd.read_sql("SELECT * FROM population", engine)
hospitals    = pd.read_sql("SELECT * FROM hospitals", engine)
education    = pd.read_sql("SELECT * FROM education", engine)

print("تم سحب البيانات:", population.shape, hospitals.shape, education.shape)

# ------------------------------------------------------------
# 3) هل فيه علاقة بين حجم السكان والتغطية الصحية (أسرّة لكل 1000 نسمة)؟
#    نتوقع منطقيًا إنه ما فيه علاقة قوية، لأن beds_per_1000 أصلاً معدّل بالسكان

merged = population.merge(hospitals, on="governorate_id")
corr, p_value = stats.pearsonr(merged["total_population"], merged["beds_per_1000"])
print(f"\nمعامل الارتباط بين حجم السكان والأسرّة لكل 1000 نسمة: {corr:.2f} (p={p_value:.3f})")
if p_value < 0.05:
    print("العلاقة معنوية إحصائيًا (p < 0.05)")
else:
    print("لا توجد علاقة معنوية إحصائيًا — حجم المحافظة لا يحدد جودة التغطية الصحية نسبيًا")

# ------------------------------------------------------------
# 4) هل الفرق بين البنين والبنات بعدد الطلاب لكل معلم "حقيقي" إحصائيًا؟
#    نجمع لكل محافظة معدل الطلاب/معلم للبنين ومقارنته بنفس المحافظة للبنات
#    (Paired t-test لأن كل محافظة قيست مرتين: مرة بنين ومرة بنات)

by_gov_gender = (
    education.groupby(["governorate_id", "gender"])
    .apply(lambda d: d["students"].sum() / d["teachers"].sum())
    .reset_index(name="students_per_teacher")
)
pivot = by_gov_gender.pivot(index="governorate_id", columns="gender", values="students_per_teacher").dropna()

t_stat, p_value = stats.ttest_rel(pivot["Boys"], pivot["Girls"])
print(f"\nمتوسط الطلاب/معلم - بنين: {pivot['Boys'].mean():.2f}  |  بنات: {pivot['Girls'].mean():.2f}")
print(f"Paired t-test: t={t_stat:.2f}, p={p_value:.3f}")
if p_value < 0.05:
    print("الفرق بين البنين والبنات معنوي إحصائيًا")
else:
    print("الفرق بين البنين والبنات غير معنوي إحصائيًا — يعتبر ضمن التذبذب الطبيعي")

# ------------------------------------------------------------
# 5) رسم بياني: التغطية الصحية حسب المحافظة (نحفظه كصورة نستخدمها لاحقًا)

chart_df = merged.merge(governorates, on="governorate_id").sort_values("beds_per_1000", ascending=False)
plt.figure(figsize=(10, 6))
plt.barh(chart_df["governorate_name"], chart_df["beds_per_1000"], color="#2E86AB")
plt.xlabel("عدد الأسرّة لكل 1000 نسمة")
plt.title("التغطية الصحية حسب المحافظة - المنطقة الشرقية")
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig("beds_per_1000_chart.png", dpi=150)
print("\nتم حفظ الرسم البياني: beds_per_1000_chart.png")
