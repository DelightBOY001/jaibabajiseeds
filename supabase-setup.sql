-- ============================================================
-- JAI BABAJI SEEDS — Supabase Database Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. VARIETIES TABLE
create table if not exists varieties (
  id serial primary key,
  name text not null,
  badge text,
  description text,
  price integer,
  cook_time text,
  best_for text,
  rating_labels text[] default array['Aroma','Taste','Fluffiness'],
  rating_vals integer[] default array[80,80,80],
  img_url text default '',
  active boolean default true,
  bg_grad text,
  sort_order integer default 0,
  created_at timestamptz default now()
);

-- 2. INQUIRIES TABLE
create table if not exists inquiries (
  id serial primary key,
  name text,
  company text,
  variety text,
  qty text,
  phone text,
  message text,
  status text default 'new',
  created_at timestamptz default now()
);

-- 3. SETTINGS TABLE
create table if not exists settings (
  id integer primary key default 1,
  company_name text default 'Jai Babaji Seeds',
  tagline text default 'Pure Fields. Pure Taste.',
  phone text default '+91 98765 43210',
  email text default 'info@jaibababjiseeds.com',
  address text default 'Grain Market Road, Rohtak, Haryana – 124001',
  stat_years integer default 19,
  stat_farmers integer default 500,
  stat_tonnes integer default 25000,
  stat_clients integer default 10000,
  show_compare boolean default true,
  show_testimonials boolean default true,
  show_whatsapp boolean default true
);

-- 4. STORAGE BUCKET for rice images
insert into storage.buckets (id, name, public)
values ('rice-images', 'rice-images', true)
on conflict do nothing;

-- 5. STORAGE POLICY — allow anyone to view images
create policy "Public read rice images"
on storage.objects for select
using ( bucket_id = 'rice-images' );

-- 6. STORAGE POLICY — allow admin to upload
create policy "Allow uploads to rice-images"
on storage.objects for insert
with check ( bucket_id = 'rice-images' );

create policy "Allow delete from rice-images"
on storage.objects for delete
using ( bucket_id = 'rice-images' );

-- 7. ROW LEVEL SECURITY — allow public reads on varieties & settings
alter table varieties enable row level security;
alter table inquiries enable row level security;
alter table settings enable row level security;

create policy "Public can read varieties" on varieties for select using (true);
create policy "Public can read settings" on settings for select using (true);
create policy "Anyone can insert inquiry" on inquiries for insert with check (true);
create policy "Admin can do all on varieties" on varieties for all using (true);
create policy "Admin can do all on inquiries" on inquiries for all using (true);
create policy "Admin can do all on settings" on settings for all using (true);

-- 8. DEFAULT SETTINGS ROW
insert into settings (id) values (1) on conflict do nothing;

-- 9. SEED DEFAULT VARIETIES
insert into varieties (name, badge, description, price, cook_time, best_for, rating_labels, rating_vals, bg_grad, sort_order) values
('Premium Basmati',  'Premium',    'Long extra-long grain with signature fragrance. The king of rice varieties.',               120, '15 min', 'Biryani, Pulao',      array['Aroma','Taste','Fluffiness'], array[95,92,90], 'linear-gradient(135deg,#2C5F2E,#4A8C4C)', 1),
('Brown Basmati',    'Health+',    'Whole grain with bran intact. Nutty flavour, rich in fibre and nutrients.',                  140, '25 min', 'Health meals',        array['Nutrition','Aroma','Taste'],   array[98,75,82], 'linear-gradient(135deg,#5D4E37,#8B7355)', 2),
('Parboiled (Sela)', 'Daily Use',  'Partially boiled in the husk. Non-sticky, firm grains. Perfect for everyday use.',           65, '12 min', 'Daily cooking',       array['Texture','Value','Taste'],     array[88,96,78], 'linear-gradient(135deg,#1A6B8A,#2B9BBF)', 3),
('Sharbati Rice',    'Restaurant', 'Extra-long slender grain with mild aroma. Premium choice for restaurants.',                   95, '15 min', 'Restaurants, Hotels', array['Length','Aroma','Taste'],      array[97,70,88], 'linear-gradient(135deg,#7B4F9E,#A070C5)', 4),
('Steam Rice',       'South India','Short grain, soft texture. Ideal for idli, dosa, and South Indian dishes.',                   55, '10 min', 'South Indian',        array['Softness','Value','Taste'],    array[93,98,80], 'linear-gradient(135deg,#C25E00,#E8882A)', 5),
('Golden Sella',     'Catering',   'Golden-hued grains, supremely fluffy. Top choice for hotels and catering.',                   85, '18 min', 'Hotels, Catering',    array['Fluffiness','Aroma','Texture'],array[96,80,92], 'linear-gradient(135deg,#9A7B00,#D4A800)', 6)
on conflict do nothing;

-- ============================================================
-- DONE! Now copy your Project URL and anon key from:
-- Supabase Dashboard → Settings → API
-- ============================================================
