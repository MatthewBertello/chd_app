-- Database schema for supabase chd_app

-- Create enum types
create type variable_category as enum (
    'Demographic',
    'Social',
    'Physical',
    'Mental'
);

create type race as enum (
    'White',
    'Black',
    'Hispanic',
    'Asian',
    'American Indian',
    'Other'
);

create type marital_status as enum (
    'Single',
    'Married',
    'Divorced',
    'Partner',
    'Widowed',
    'Other'
);

create type gender as enum (
    'Male',
    'Female',
    'Decline to answer'
);

create type education_level as enum (
    'K-6',
    'Some High School',
    'Completed High School',
    'Some College',
    'Technical College',
    'College Graduate',
    'Graduate Level'
);

-- Create a table for public profiles
-- Create a table for public profiles
create table profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone
);
-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/auth/row-level-security for more details.
alter table profiles
  enable row level security;

create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

create policy "Users can insert their own profile." on profiles
  for insert with check ((select auth.uid()) = id);

create policy "Users can update own profile." on profiles
  for update using ((select auth.uid()) = id);

-- This trigger automatically creates a profile entry when a new user signs up via Supabase Auth.
-- See https://supabase.com/docs/guides/auth/managing-user-data#using-triggers for more details.
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Create the user_info table
create table if not exists user_info (
    user_id uuid references auth.users not null primary key,
    date_of_birth date,
    race race,
    gender gender,
    marital_status marital_status,
    education_level education_level
);


-- Create the variable_definitions table
create table if not exists variable_definitions (
    id integer generated always as identity primary key,
    name text not null,
    category variable_category not null,
    description text,
    unit text
);



-- Create the variable_entries table
create table if not exists variable_entries (
    id integer generated always as identity primary key,
    user_id uuid references auth.users not null,
    variable_id integer references variable_definitions not null,
    value numeric,
    date timestamptz not null
);

-- Insert some sample data
insert into
    variable_definitions (name, category, description, unit)
values
    ('Kick count', 'Physical', null, 'count'),
    ('Heart rate', 'Physical', null, 'bpm'),
    ('Sleep duration', 'Physical', null, 'hours'),
    ('Anxiety level', 'Mental', null, '1-10 scale'),
    ('Depression level', 'Mental', null, '1-10 scale'),
    ('Water intake', 'Physical', null, 'oz');