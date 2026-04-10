# Design System Document: Kinetic Precision

## 1. Overview & Creative North Star: "The Neon Lab"
This design system moves away from the generic "health and wellness" aesthetic of soft greens and sterile whites. Instead, it embraces **The Neon Lab**—a Creative North Star that combines the high-performance energy of elite athletics with the precision of laboratory science. 

The experience is defined by **Atmospheric Depth**. We reject the flat, "boxy" layout of standard e-commerce. Instead, we use intentional asymmetry, expansive typography, and layered translucent surfaces to create a UI that feels like a high-end heads-up display (HUD). The goal is to make the user feel like they are "tuning" their body through a premium, data-driven interface.

---

## 2. Colors & Surface Architecture
The palette is rooted in deep obsidian tones, punctuated by a "Vibrant Blue" that acts as a high-energy catalyst.

### The "No-Line" Rule
**Prohibit 1px solid borders for sectioning.** To define boundaries, use shifts in background color or vertical whitespace. A section should never be "boxed in" by a stroke; it should emerge from the background through tonal elevation.

### Surface Hierarchy & Nesting
Depth is achieved by stacking `surface-container` tiers. This creates a tactile, physical feel without relying on dated skeuomorphism.
- **Base Layer:** `surface` (#0e0e0e) with a subtle 16px grid overlay (opacity 5%).
- **Sectioning:** Use `surface-container-low` (#131313) for large content areas.
- **Floating Elements:** Use `surface-container-highest` (#262626) for cards that need to "pop" against the background.

### The "Glass & Gradient" Rule
Standard buttons are replaced with **Signature CTAs**. Main actions must use a linear gradient from `primary` (#95aaff) to `primary-dim` (#3766ff) at a 135-degree angle. For floating navigation or modal overlays, apply a `backdrop-blur` (20px) to a semi-transparent `surface-container` to create a "frosted obsidian" effect.

---

## 3. Typography: Editorial Authority
We utilize a high-contrast pairing: **Space Grotesk** for technical, bold authority and **Manrope** for modern, ergonomic readability.

*   **Display & Headlines (Space Grotesk):** Use `display-lg` and `headline-lg` for product names and category titles. These should be tight-tracked (-2%) to feel aggressive and impactful.
*   **Body & Titles (Manrope):** All functional text uses Manrope. Its geometric yet friendly curves balance the "brutalist" feel of the headlines.
*   **The Scale of Importance:** Use `label-md` in all-caps with 10% letter spacing for technical specs (e.g., "500MG CREATINE") to mimic laboratory labeling.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are largely forbidden. Hierarchy is communicated through light, not shadow.

*   **The Layering Principle:** Place a `surface-container-lowest` card inside a `surface-container-high` section to create a "recessed" look. This "in-set" styling feels more integrated than a standard "drop-on-top" card.
*   **Ambient Glow:** For high-priority elements (like a "Buy Now" button), use an ambient glow instead of a shadow. Apply a blur of 30px to the `primary` color at 15% opacity behind the element.
*   **The Ghost Border Fallback:** If accessibility requires a container edge, use a `outline-variant` (#484847) at **15% opacity**. It should be felt, not seen.

---

## 5. Components: Precision Primitives

### Buttons & Interaction
- **Primary:** Gradient fill (`primary` to `primary-dim`), `xl` roundedness (1.5rem). No border.
- **Secondary:** `surface-container-highest` fill with a `primary` text color.
- **Tertiary:** Ghost style. No fill, no border. Use `title-sm` with a `primary` underline that expands on hover.

### The "HUD" Search Bar
The search bar is the centerpiece. It should be `surface-container-high`, `full` roundedness, and feature a subtle `primary` glow on focus. The placeholder text should use `label-md` to maintain the technical aesthetic.

### Cards & Product Grids
**Strictly forbid divider lines.** 
- Separate product info (Title, Price, Rating) using the spacing scale (e.g., 12px gap). 
- Use `xl` (1.5rem) corner radius for all product cards. 
- Category icons should be housed in "Liquid Circles"—circular containers using `secondary-container` (#3838a0) with a subtle glassmorphism blur.

### Supplement Specific Components
- **Dosage Chips:** Use `secondary` (#9193ff) with `on-secondary` (#0c0078) text. These are small, high-contrast pills that indicate serving sizes or "New" badges.
- **Performance Graph:** When showing supplement benefits, use a vector line in `tertiary` (#ffaced) against the subtle background grid.

---

## 6. Do’s and Don’ts

### Do:
- **Use Intentional Asymmetry:** Align headlines to the left but allow product imagery to bleed off the right edge of the screen to create movement.
- **Embrace the Grid:** The background grid isn't just decoration; align your component edges to the grid lines to create a "mapped" feel.
- **Layer with Purpose:** Only use the `highest` surface container for items that require immediate user interaction.

### Don't:
- **No Pure White Text:** Use `on-surface` (#ffffff) for headlines, but drop to `on-surface-variant` (#adaaaa) for body text to reduce eye strain in dark mode.
- **No 100% Opaque Borders:** High-contrast borders break the "atmospheric" feel of the system. If it looks like a box, you've failed the "No-Line" rule.
- **No Standard Red for Errors:** Use the system's `error` (#ff6e84) which is a "techno-pink" that fits the vibrant blue palette better than a traditional warning red.

---

## 7. Spacing & Rhythm
This system breathes. Use generous vertical padding (`4rem` to `6rem`) between major sections to let the high-end typography stand alone. In the "Neon Lab," clutter is the enemy of precision. Every element must have a "clearance zone" to ensure the user can focus on one data point at a time.