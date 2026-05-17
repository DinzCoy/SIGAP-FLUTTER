# SIGAP Mobile Design System Reference

Aplikasi SIGAP (Sistem Guardian Aset dan Pelayanan IT) menggunakan pendekatan **"Modern Professional"** yang menggabungkan kepercayaan tingkat enterprise dengan estetika mobile terkini.

## 1. Design Inspirations (Hybrid Model)

| Brand        | Purpose           | Key Elements                                                                  |
| :----------- | :---------------- | :---------------------------------------------------------------------------- |
| **Stripe**   | Premium Aesthetic | Soft gradients, high-quality typography, and refined shadows.                 |
| **Revolut**  | Mobile Precision  | Rounded cards (16px-24px), intuitive iconography, and fintech-style data viz. |
| **Intercom** | Friendly Utility  | Soft-colored badges/tags, accessible UI, and clear hierarchy.                 |

---

## 2. Visual Principles

### 🎨 Color Palette & Lighting

- **Core Navy:** Menggunakan `AppColors.primary` sebagai simbol otoritas dan stabilitas (IBM/Enterprise vibe).
- **Vibrant Gradients:** Area luas seperti Header dan Banner menggunakan `primaryGradient` (Stripe/Cohere vibe) agar tidak terlihat flat.
- **Soft Backgrounds:** Latar belakang tidak putih polos, melainkan menggunakan `AppColors.background` dengan pola geometris halus (PremiumBackground) untuk memberikan kedalaman (Depth).

### 📐 Layout & Shapes

- **Corner Radius:** Standardisasi di **16px - 20px**. Sudut bulat menghilangkan kesan kaku/jadul dan membuat aplikasi terasa lebih "ramah" (Modern Mobile trend).
- **Elevation:** Menghindari garis tepi (border) hitam. Gunakan `AppColors.cardShadow` yang lembut untuk membuat komponen terlihat mengambang secara alami.
- **Glassmorphism Lite:** Penggunaan container semi-transparan pada area gradasi untuk efek kedalaman yang mewah.

### 🔘 Components Style

- **Buttons:** Menggunakan gradasi atau solid color dengan bayangan yang sesuai warna tombolnya.
- **Stat Panels:** Menggunakan ikon dengan latar belakang gradasi melingkar (Circular Gradient) untuk memberikan fokus visual tanpa terlihat berlebihan.
- **Action Cards:** Menggabungkan ikon berwarna dengan deskripsi yang bersih dan _chevron_ halus sebagai penunjuk interaksi.

---

## 3. Implementation Roadmap

1. [x] Define Premium Color System & Gradients.
2. [x] Create PremiumBackground with Geometric Patterns.
3. [x] Refactor Login Page (First Impression).
4. [x] Refactor Dashboard Headers & Stat Panels.
5. [ ] Refactor List Items (Ticket & Asset) using Linear-style precision.
6. [ ] Apply Micro-animations (Tween, AnimatedContainer) to enhance interaction feel.
