-- 한을 홈페이지 Supabase 스키마
-- 웹사이트(anon 키)는 INSERT만 가능, 조회/수정/삭제는 대시보드(관리자)에서만 가능

create table if not exists public.partner_inquiries (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org text not null check (char_length(org) between 1 and 200),
  name text not null check (char_length(name) between 1 and 100),
  phone text not null check (char_length(phone) between 5 and 40),
  email text not null check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' and char_length(email) <= 200),
  area text not null check (area in ('지역 축제·골목상권','전통시장 디지털화','소상공인 AI 실습교육','기타 지자체 제휴')),
  message text not null check (char_length(message) between 1 and 5000),
  agreed boolean not null check (agreed),
  status text not null default '접수'
);

create table if not exists public.demo_logs (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  store text check (char_length(store) <= 100),
  category text check (category in ('food','bakery','craft','cafe'))
);


alter table public.partner_inquiries enable row level security;
alter table public.demo_logs enable row level security;

drop policy if exists "anon insert" on public.partner_inquiries;
drop policy if exists "anon insert" on public.demo_logs;

create policy "anon insert" on public.partner_inquiries for insert to anon with check (status = '접수');
create policy "anon insert" on public.demo_logs for insert to anon with check (true);

-- 테이블 권한: anon은 insert만
revoke all on public.partner_inquiries, public.demo_logs from anon;
grant insert on public.partner_inquiries, public.demo_logs to anon;
